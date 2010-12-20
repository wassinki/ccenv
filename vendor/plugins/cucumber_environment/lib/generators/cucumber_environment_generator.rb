require 'pathname'
require 'fileutils'

# generates the cucumber environment
class CucumberEnvironmentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
  attr_reader :plugin_dir
  attr_reader :application_name
 
   
  # initializes the generator
  def initialize(*args, &block)
    super    
    @plugin_dir = Pathname.new(File.expand_path("../../", File.dirname(__FILE__))).relative_path_from(Pathname.new(Rails.root)).to_s
    @application_name = Rails.application.class.name.split(/::/).first    
  end
  
  # method to generate the yml configuration
  def create_yaml_configuration    
    template "cucumber.yml", File.join(Rails.root, "config", "#{environment}.yml");
  end
  
  # method to generate the environment file
  def create_environment
    template "cucumber.rb", File.join(Rails.root, "config", "environments", "#{environment}.rb");
  end
  
  # method to create the gem file name
  def create_gem_file    
    #template "Gemfile", File.join(plugin_dir, "Gemfile")
    gem 'cucumber_environment', :path=>'vendor/plugins/cucumber_environment', :group => environment.to_sym
  end
  
  # method to create the features directory
  def create_features_directory
    # create directories for step definitions
    support_directory = File.join(Rails.root, "test", "features", "support") 
    FileUtils.mkpath support_directory
    # copy path template
    template "paths.rb", File.join(support_directory, "paths.rb")
    
    # create directories for different environments
    (cucumber_environments.values.uniq).each do |env|
      # features directory
      FileUtils.mkpath File.join(Rails.root, "test", "features", env)
      
      # step defintions directory
      FileUtils.mkpath File.join(Rails.root, "test", "features", "step_definitions", env)
    end
  end
  
  # method to create the ccenv script
  def create_ccenv_script
    target = File.join(Rails.root, "script", "ccenv")    
    template "ccenv", target
    File.chmod 0755, target    
  end
  
  # method to create notes
  def create_notes
    puts "Please set the CUCUMBER_ENV_HOME variable to #{plugin_dir} in your .profile"
    puts "Create a softlink of the ccenv file by 'ln -s script/ccenv ~/bin/'"
    puts
    puts "Required dependencies:"    
    File.open(File.join(plugin_dir, "cucumber_environment.gemspec"), "r") do |f|
      while(line = f.gets) do
        next unless line.match /s\.add_dependency\("([^"]+)"/        
        puts "sudo gem install #{$1}"
      end 
    end       
  end
  
  private
  
  # determines all available environment names
  def cucumber_environments
    environments = Dir[File.expand_path('../cucumber_environment/environments/*.rb', File.dirname(__FILE__))].inject({}) do|env, file|
      environment_name = File.basename(file).gsub(".rb", "");
      env[environment_name] = environment_name
      env
    end    
    environments['default'] = environments.values.include?('mechanize')  ? 'mechanize' : envs.first
    
    environments
  end    
  
  # returns the cucumber environment that is passed (it is called the class_name in the generator)
  def environment
    class_name.underscore
  end
  
  # returns the default step definitions
  def step_definitions    
    Dir[File.join(plugin_dir, "lib", "cucumber_environment", "step_definitions", "*.rb")]    
  end
end

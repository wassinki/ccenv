require 'fileutils'

# task to generate the feature dir
namespace :cucumber do

	desc "Generates feature dir"
	task :create_feature_dir, :p do |function,args|  	
    features_dir = File.join(File.expand_path(args[:p] || "./"), "features")
     
    support_directory = File.join(features_dir, "support") 
    FileUtils.mkpath support_directory    
    # copy path template
    File.open(File.join(File.dirname(__FILE__), "..", "generators", "templates", "paths.rb"), "r") do |input|
      File.open(File.join(features_dir, "support", "paths.rb"), "w") do |output|
        while line = input.gets        
          output.print line.gsub("<%= application_name.underscore %>", "app")
        end
      end
    end
    
    # create directories for different environments
    (cucumber_environments.values.uniq).each do |env|
      # features directory
      FileUtils.mkpath File.join(features_dir, env)
      
      # step defintions directory
      FileUtils.mkpath File.join(features_dir, "step_definitions", env)
    end
	end
  
  
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

end
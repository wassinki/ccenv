AfterConfiguration do |config|
  config.feature_dirs.each do |directory|    
    # load support and step definitions files
    if File.exists?(directory) && File.directory?(directory)
      # load additional environment settings
      environment_settings = File.join(directory, "environments", "#{config.environment.to_s}.rb")
      if File.exists? environment_settings
        require environment_settings
      end
    
      # load step definitions, supports
      profile_step_definitions =  File.join("step_definitions", config.environment.to_s)    
      (%w(support step_definitions) << profile_step_definitions).each do |sub_directory|
        path = File.join(directory, sub_directory)      
        if File.directory?(path)        
          Dir[File.join(path, "*.rb")].each{|f| require f}           
        end
      end 
    end
  end  
end

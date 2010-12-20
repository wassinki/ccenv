# This version not automatically loads all features, but depending on the environment that is loaded
# It also loads the general features, stored in the root
module Cucumber
  module Cli
    class Configuration
      def environment
        return [:rack, :rails].include?(Webrat.configuration.mode) ? :webrat : Webrat.configuration.mode
      end
      
      def paths
        @options[:paths].empty? ? ['test/features'] : @options[:paths]
      end
      
      # search in path for features and in subdirectory of the given mode
      def feature_files
        potential_feature_files = paths.map do |path|
          path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
          path = path.chomp('/')         
          if File.directory?(path)
            Dir["#{path}/*.feature"] + Dir["#{path}/#{environment.to_s}/**/*.feature"]
          elsif path[0..0] == '@' and # @listfile.txt
              File.file?(path[1..-1]) # listfile.txt is a file
            IO.read(path[1..-1]).split
          else
            path
          end
        end.flatten.uniq
        remove_excluded_files_from(potential_feature_files)
        potential_feature_files
      end
    end
  end
end


require File.join(File.dirname(__FILE__), "..", "test_helper")

require 'rails_generator'
require 'rails_generator/scripts/generate'
 
class CucumberEnvironmentGeneratorTest < Test::Unit::TestCase
 
  # creates a fake rails root
  def setup
    FileUtils.mkdir_p(fake_rails_root)
    @original_files = file_list
  end
 
  # removes the fake rails root
  def teardown
    FileUtils.rm_r(fake_rails_root)
  end
 
  # test the cucumber file generation
  def test_generates_correct_file_name
    Rails::Generator::Scripts::Generate.new.run(["cucumber_environment"], :destination => fake_rails_root)
    new_file = (file_list - @original_files).first
    assert_equal "cucumber.yml", File.basename(new_file)
  end
 
  private
 
    def fake_rails_root
      File.join(File.dirname(__FILE__), 'fake_rails_root')
    end
 
    def file_list
      Dir.glob(File.join(fake_rails_root, "*"))
    end
 
end
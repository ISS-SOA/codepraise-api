require 'factory_bot'
require_relative '../../app/infrastructure/database/orms/init'

Dir.glob("#{File.dirname(__FILE__)}/*_factory.rb").each do |file|
  require file
end

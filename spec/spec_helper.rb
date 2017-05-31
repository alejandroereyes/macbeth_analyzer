require "rspec"
require "pry"
Dir[File.expand_path("../../lib/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.color = true
end

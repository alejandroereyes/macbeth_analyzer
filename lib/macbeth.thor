require "thor"
require "pry"
Dir[File.expand_path("../**/*.rb", __FILE__)].each { |f| require f }

class Macbeth < Thor
  FILE_PATH = File.expand_path("../../macbeth.txt", __FILE__)

  desc "character_lines", "takes the name of a character from Shakespeare's play Macbeth and returns the number of lines spoken by that character"
  def character_lines(given_name)

  end
end

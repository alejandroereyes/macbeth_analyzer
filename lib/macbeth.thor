require "thor"
Dir[File.expand_path("../**/*.rb", __FILE__)].each { |f| require f }

class Macbeth < Thor
  include Parse
  FILE_PATH = File.expand_path("../../macbeth.txt", __FILE__).freeze

  desc "character_lines", "takes the name of a character from Shakespeare's play Macbeth and returns the number of lines spoken by that character"
  def character_lines(given_name)
    total_lines = total_lines_for_character(given_name, File.read(FILE_PATH))

    puts "\n#{given_name} has #{total_lines} lines."
  end
end

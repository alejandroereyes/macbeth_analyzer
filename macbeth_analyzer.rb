require_relative "./lib/xml_play"
require "open-uri"

machbeth = XmlPlay.new Nokogiri::XML(open("http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"))

puts ""
machbeth.speakers_line_map(exclude: ["ALL"]).each do |speaker, line_count|
  puts "#{line_count} #{speaker}"
end

require "nokogiri"
class XmlPlay
  attr_reader :play

  def initialize(play)
    @play = play
  end

  def speakers_line_map(only: [], exclude: [])
    speakers_map = init_speaker_line_map(extract_speakers(only: only, exclude: exclude))

    play.xpath("//SPEECH").each do |speech|
      speaker = extract_speaker_from(speech)
      next unless speakers_map.key?(speaker)

      lines = extract_lines_from(speech)
      speakers_map[speaker] += lines.count
    end
    speakers_map
  end

  def extract_lines_from(node)
    target_node = "LINE"
    node.children.select { |child| child.name == target_node }
  end

  def extract_speaker_from(node)
    target_node = "SPEAKER"
    node.children.select { |child| child.name == target_node }.first.children.first.text
  end

  def init_speaker_line_map(speakers)
    speakers.each_with_object(Hash.new(0)) { |speaker, hsh| hsh[speaker] = hsh.default }
  end

  def extract_speakers(only: [], exclude: [])
    speakers = play.xpath("//SPEAKER").map { |node| node.children.first.text }.uniq
    speakers = remap_strings_for_included_items(speakers, :select, only) unless only.empty?
    speakers = remap_strings_for_included_items(speakers, :reject, exclude) unless exclude.empty?
    speakers
  end

  def remap_strings_for_included_items(arr, operation, ref=[])
    normalized_ref = ref.map(&:upcase)
    arr.send(operation) { |str| normalized_ref.include? str.upcase }
  end
end

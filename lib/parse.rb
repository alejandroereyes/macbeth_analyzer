module Parse

  NEW_SECTION_IDENTIFIERS = %w(Scene Act).freeze

  def total_lines_for_character(given_name, source_str)
    target_character    = normalize(given_name)
    current_character   = ""
    found_character     = false
    found_line          = false
    total_lines         = 0

    StringIO.new(source_str).readlines.each do |line|
      if character_name?(line) || spoken_line?(line)
        found_character   = character_name?(line)
        found_line        = spoken_line?(line)
        current_character = found_character ? normalize(line) : current_character

        if current_character == target_character
          total_lines += 1 if found_line
        end
      end
    end
    total_lines
  end

  def normalize(str)
    str.gsub("_", " ").split(" ").map do |current_str|
      "#{current_str[0].upcase}#{current_str[1..-1].downcase}"
    end.join(" ").strip
  end

  def first_word(str)
    normalize(str).split(" ").first
  end

  def character_name?(str)
    alpha_numeric?(str) && !blank_space?(str[0]) && !new_section?(str)
  end

  def spoken_line?(str)
    str[0..3].split.all? { |char| blank_space?(char) } && alpha_numeric?(str)
  end

  def new_section?(str)
    NEW_SECTION_IDENTIFIERS.any? { |id| id.include?(first_word(str)) }
  end

  def newline?(str)
    str == "\n"
  end

  def blank_space?(str)
    str == " "
  end

  def alpha_numeric?(str)
    !str.match(/[a-z0-9]/i).nil?
  end
end

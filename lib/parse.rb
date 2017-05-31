module Parse

  def normalize(str)
    str.gsub("_", " ").split(" ").map do |current_str|
      "#{current_str[0].upcase}#{current_str[1..-1].downcase}"
    end.join(" ")
  end
end

module Helpers::Kerning
  extend self

  KERNING_DATA = {{ `cat res/data/kerning.dat` }}
  AVERAGE_CHAR_WIDTH = KERNING_DATA.each.select { |tuple| tuple[0].size == 1 }.sum { |tuple| tuple[1] } / KERNING_DATA.size

  def text_width(text : String)
    raw_width = text.each_char.sum(0.0) { |char| KERNING_DATA[char.to_s]? || AVERAGE_CHAR_WIDTH }

    if text.size == 1
      raw_width
    else
      spacing = 0.0

      text.each_char.each_cons(2) do |chars|
        ngram = chars.sum("")
        if ngram.size > 1
          spacing += KERNING_DATA[ngram]? || 0.0
        end
      end

      raw_width + spacing
    end
  end
end

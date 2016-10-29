require 'mecab'

#sentence = "ゲームしてからスケベしよう"
def pickup_noun sentence

  mecab = MeCab::Tagger.new
  node = mecab.parseToNode(sentence)
  word_array = []

  begin
    node = node.next
    if /^名詞/ =~ node.feature.force_encoding("UTF-8")
      word_array << node.surface.force_encoding("UTF-8")
    end
  end until node.next.feature.include?("BOS/EOS")

  puts "word_array: #{word_array}"
  return word_array
end

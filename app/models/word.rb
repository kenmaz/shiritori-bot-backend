class Word < ActiveRecord::Base
  has_many :game_words
  has_many :games, through: :game_words

  # @return [:code => :ok, :word => <word>]
  # @return [:code => (:out|:invalid), :msg => ".."]
  def self.check(text, game)
    res = register(text)
    case res[:code]
    when :ok
      word = res[:word]

      if game.words.include?(word)
        return {:code => :out, :msg => "「#{word.value}」は既に言ったよ！！あなたの負け！"}
      end

      if last_word = game.words.last
        puts "last #{last_word.value}"
      end
    end
    return res
  end

  def self.register(text)
    kana = text.tr('ァ-ン','ぁ-ん')
    unless /\p{hiragana}/.match(kana)
      return {:code => :invalid, :msg => "ひらがなorカタカナでお願いします"}
    end

    if text.end_with?("ん")
      return {:code => :out, :msg => "「ん」で終わってる！あなたの負け！"}
    end

    if word = Word.where(kana: kana).take
      word.cnt += 1
    else
      word = Word.new(kana: kana, value: text, cnt: 1)
    end
    word.save!

    return {:code => :ok, :word => word}
  end

  # @return [:code => :ok, :word => <word>]
  # @return [:code => :out]
  def self.answer(text, game)
    unless text
      return {:code => :ok, :word => Word.take}
    end

    kana = text.tr('ァ-ン','ぁ-ん')
    ch = kana[-1]
    cand_words = Word.where("kana LIKE '#{ch}%'")
    cand_words.each do |cand_word|
      unless game.words.include?(cand_word)
        return {:code => :ok, :word => cand_word}
      end
    end

    return {:code => :out}
  end
end

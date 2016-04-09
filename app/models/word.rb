class Word < ActiveRecord::Base
  has_many :game_words
  has_many :games, through: :game_words

  # @return [:code => :ok, :word => <word>]
  # @return [:code => (:out|:invalid), :msg => ".."]
  def self.check(text)
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
  def self.answer(text)
    if text
      kana = text.tr('ァ-ン','ぁ-ん')
      ch = kana[-1]
      if word = Word.where("kana LIKE '#{ch}%'").take
        return {:code => :ok, :word => word}
      else
        return {:code => :out}
      end
    else
      unless word = Word.take
        word = Word.create!(kana: "おれお", value: "オレオ", cnt: 1)
      end
      return {:code => :ok, :word => word}
    end
  end
end

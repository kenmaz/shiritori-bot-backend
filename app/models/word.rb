class Word < ActiveRecord::Base
  has_many :game_words
  has_many :games, through: :game_words

  # @return [:code => (:ok|:out|:invalid), :msg => ".."]
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
      word = Word.new(kana: kana, cnt: 1)
    end
    word.save!

    return {:code => :ok}
  end

  def self.answer(text)
    if text
      kana = text.tr('ァ-ン','ぁ-ん')
      ch = kana[-1]
      return "なにか"
    else
      return "オレオ"
    end
  end
end

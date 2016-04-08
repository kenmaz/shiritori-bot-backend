class Word < ActiveRecord::Base
  has_many :game_words
  has_many :games, through: :game_words

  # @return [:code => (:ok|:out|:invalid), :msg => ".."]
  def self.check(text)
    return {:code => :ok}
  end

  def self.answer(text)
    if text
      return "なにか"
    else
      return "オレオ"
    end
  end
end

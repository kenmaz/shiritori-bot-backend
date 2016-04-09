class Game < ActiveRecord::Base
  belongs_to :user
  has_many :game_words
  has_many :words, through: :game_words

  def self.process(mid, text)
    res = []

    case text
    when '/list'
      return list(mid)
    end

    is_new_user = false
    unless user = User.where(mid: mid).take
      user = User.create(:mid => mid)
      is_new_user = true
    end

    is_new_game = false
    unless game = Game.where(user_id: user.id).take
      game = Game.create(:user => user)
      is_new_game = true
    end

    if is_new_user
      res << "こんにちは"
      res << "しりとり、やりましょうよ"
      res << ""
    end

    if text
      res << "なるほど、「#{text}」ですか"
      result = Word.check(text)
      case result[:code]
      when :ok then
        ans = Word.answer(text)
        case ans[:code]
        when :ok then
          res << "じゃあわたしは・・・"
          res << "「#{ans[:text]}」！"
        when :out then
          res << "参りました。何も思いつかない"
        end
      when :out then
        res << "はい〜、わたしの勝ち〜"
        res << "#{result[:msg]}"
      when :invalid then
        res << "ちょっとちょっと、#{result[:msg]}"
      else
        res << "なんかおかしい、管理者に報告して！"
      end
    else
      ans = Word.answer(nil)
      res << "じゃあわたしから"
      res << "「#{ans[:text]}」！"
    end

    res.join("\n")
  end

  def list(mid)
    unless user = User.where(mid: mid).take
      return "no user #{mid}"
    end
    unless game = Game.where(user_id: user.id).take
      return "no game #{mid}"
    end
    res = []
    game.words.each do |word|
      res << word.kana
    end
    res.join("\n")
  end
end

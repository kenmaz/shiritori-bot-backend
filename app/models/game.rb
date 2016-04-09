class Game < ActiveRecord::Base
  belongs_to :user
  has_many :game_words
  has_many :words, through: :game_words

  def self.process(mid, text)

    is_new_game = false

    unless user = User.where(mid: mid).take
      user = User.create(:mid => mid)
      is_new_game = true
    end

    unless game = Game.where(user_id: user.id).where(end_date: nil).take
      game = Game.create(:user => user)
      is_new_game = true
    end

    game.start_game(text, is_new_game)
  end

  def start_game(text, is_new_game)
    res = nil
    if is_new_game || text == nil
      res = reply_first()
    else
      case text
      when '/list'
        res = list()
      else
        res = reply(text)
      end
    end
    res.join("\n")
  end

  def answer_and_save(text)
    ans = Word.answer(text, self)
    case ans[:code]
    when :ok
      puts word = ans[:word]
      self.words << word
      self.save!
      return word
    when :out
      return nil
    end
  end

  def check_and_save(text)
    result = Word.check(text, self)
    case result[:code]
    when :ok
      word = result[:word]
      if self.words.include?(word)
        return {:code => :out, :msg => "「#{word.value}」は既に言ったよ！！あなたの負け！"}
      end
      self.words << word
      self.save!
    end
    result
  end

  def reply_first
    res = []
    res << "こんにちは"
    res << "しりとり、やりましょうよ"
    res << ""
    word = answer_and_save(nil)
    res << "じゃあわたしから"
    res << "「#{word.value}」！"
  end

  def reply(text)
    res = ["なるほど、「#{text}」ですか"]
    result = check_and_save(text)

    case result[:code]
    when :ok
      if word = answer_and_save(text)
        res << "じゃあわたしは・・・"
        res << "「#{word.value}」！"
      else
        res << "参りました。何も思いつかない"
        finish
        res << "もう一回やる？"
      end
    when :out
      res << "はい〜、わたしの勝ち〜"
      res << "#{result[:msg]}"
      finish
      res << "もう一回やる？"
    when :invalid
      res << "ちょっとちょっと、#{result[:msg]}"
    else
      res << "なんかおかしい、管理者に報告して！"
      finish
      res << "もう一回やる？"
    end

    return res
  end

  def list
    res = [">"]
    self.words.each do |word|
      res << word.value
    end
    return res
  end

  def finish
    self.end_date = DateTime.now
    self.save!
  end
end

class AddFirstSample < ActiveRecord::Migration
  def change
    list = %w(あさり いるか うみがめ えだまめ おとめ カゴメ きくらげ くちびる けんこう こども ささみ しまうま するめ せんそう そうじ タンス ちくわ つみき てんどん とうもろこし なかま にら ぬりかべ ねこ のり はんこ ひる ふくおか へんぺいそく ほらあな まり みみず むだぼね めだま モスクワ やさい ゆとり よじょうはん わし がさつ ぎんこう グループ げっこう ゴミ ざんぞう じゆう ずるむけ ぜんざい ゾンビ ダンス でんわ ドワンゴ バカ ビル ブッシュ べんとう ぼうそうぞく)
    list.each do |text|
      Word.register(text)
    end
  end
end

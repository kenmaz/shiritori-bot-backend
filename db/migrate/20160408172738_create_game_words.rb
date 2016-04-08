class CreateGameWords < ActiveRecord::Migration
  def change
    create_table :game_words do |t|
      t.column :game_id, :integer
      t.column :word_id, :integer
      t.timestamps null: false
    end
  end
end

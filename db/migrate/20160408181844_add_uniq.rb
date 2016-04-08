class AddUniq < ActiveRecord::Migration
  def change
    add_index :users, :mid, :unique => true
    add_index :words, :kana, :unique => true
    add_index :words, :cnt
  end
end

class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.column :value, :string, null: false
      t.column :kana, :string, null: false
      t.column :cnt, :integer, null: false
      t.timestamps null: false
    end
  end
end

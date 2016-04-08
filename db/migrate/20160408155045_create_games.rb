class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.column :user_id, :integer
      t.timestamps null: false
    end
  end
end

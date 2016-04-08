class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :mid, :string, null: false
      t.timestamps null: false
    end
  end
end

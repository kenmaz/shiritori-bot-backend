class AddEndDateToGame < ActiveRecord::Migration
  def change
    add_column :games, :end_date, :datetime
  end
end

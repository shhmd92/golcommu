class AddRateToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rate, :float
  end
end

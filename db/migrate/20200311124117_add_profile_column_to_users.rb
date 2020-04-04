class AddProfileColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sex, :integer
    add_column :users, :birth_date, :date
    add_column :users, :prefecture, :integer
    add_column :users, :introduction, :text
    add_column :users, :play_type, :integer
    add_column :users, :score_average, :integer
  end
end

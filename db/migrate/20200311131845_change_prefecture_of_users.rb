class ChangePrefectureOfUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :prefecture, :integer, default: 0
  end

  def down
    change_column :users, :prefecture, :integer
  end
end

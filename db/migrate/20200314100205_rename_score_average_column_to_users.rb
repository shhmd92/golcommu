class RenameScoreAverageColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :score_average, :average_score
  end
end

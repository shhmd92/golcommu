class AddPlaceToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :place, :string
    add_column :events, :address, :string
    add_column :events, :course_id, :integer
  end
end

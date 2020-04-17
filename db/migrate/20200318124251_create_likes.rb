class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :event, foreign_key: false
      t.references :user, foreign_key: false

      t.timestamps
    end
  end
end

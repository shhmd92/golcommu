class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.string :image
      t.integer :maximum_participants, default: 0
      t.references :user, foreign_key: false

      t.timestamps
    end
    add_index :events, [:user_id, :created_at]
  end
end

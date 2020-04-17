class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :user, foreign_key: false
      t.references :event, foreign_key: false

      t.timestamps
    end
  end
end

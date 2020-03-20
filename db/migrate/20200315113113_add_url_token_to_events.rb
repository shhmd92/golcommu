class AddUrlTokenToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :url_token, :string
  end
end

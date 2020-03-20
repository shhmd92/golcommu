class AddEventDateToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :event_date, :date
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
  end
end

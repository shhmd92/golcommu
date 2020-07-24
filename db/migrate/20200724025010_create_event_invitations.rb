class CreateEventInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :event_invitations do |t|
      t.integer :event_id, null: false
      t.integer :invited_user_id, null: false
      t.integer :invitation_status, null: false

      t.timestamps
    end

    add_index :event_invitations, :event_id
    add_index :event_invitations, :invited_user_id
  end
end

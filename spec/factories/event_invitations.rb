# == Schema Information
#
# Table name: event_invitations
#
#  id                :bigint           not null, primary key
#  invitation_status :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  event_id          :integer          not null
#  invited_user_id   :integer          not null
#
# Indexes
#
#  index_event_invitations_on_event_id         (event_id)
#  index_event_invitations_on_invited_user_id  (invited_user_id)
#
FactoryBot.define do
  factory :event_invitation do
    
  end
end

class ParticipantsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    unless @event.already_participated?(current_user)
      @event.participate(current_user)
    end

    update_event_invitation_status(EventInvitation::ACCEPTED)

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @event = Participant.find(params[:id]).event
    @event.stop_participate(current_user)

    update_event_invitation_status(EventInvitation::REJECTED)

    redirect_back(fallback_location: root_path)
  end

  private

  def update_event_invitation_status(invitation_status)
    @event_invitation = EventInvitation.search_invitation(@event.id, current_user.id)
    if @event_invitation.present?
      @event_invitation.invitation_status = invitation_status
      @event_invitation.save
    end
  end
end

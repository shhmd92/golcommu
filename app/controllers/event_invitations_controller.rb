class EventInvitationsController < ApplicationController
  before_action :authenticate_user!

  def update
    @event_invitation = EventInvitation.find_by(id: params[:id])
    @event_invitation.update(event_invitation_params)
    redirect_back(fallback_location: root_path)
  end

  def event_invitation_params
    params.require(:event_invitation).permit(:invitation_status)
  end
end

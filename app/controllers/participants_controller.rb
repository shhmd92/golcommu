class ParticipantsController < ApplicationController
  def create
    @participant = current_user.participants.create(event_id: params[:event_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @participant = Participant.find_by(event_id: params[:event_id], user_id: current_user.id)
    @participant.destroy
    redirect_back(fallback_location: root_path)
  end
end

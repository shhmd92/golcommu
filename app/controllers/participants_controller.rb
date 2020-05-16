class ParticipantsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @event.participate(current_user) unless @event.already_participated?(current_user)
    @event.create_notification_participate!(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @event = Participant.find(params[:id]).event
    @event.stop_participate(current_user)
    redirect_back(fallback_location: root_path)
  end
end

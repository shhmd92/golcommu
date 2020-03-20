class LikesController < ApplicationController
  def create
    @like = current_user.likes.create(event_id: params[:event_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like = Like.find_by(event_id: params[:event_id], user_id: current_user.id)
    @like.destroy
    redirect_back(fallback_location: root_path)
  end
end

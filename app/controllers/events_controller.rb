class EventsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def new
    @event = current_user.events.build if user_signed_in?
  end

  def show
    @event = Event.find_by(url_token: params[:url_token])
    @like = Like.new
    @comments = @event.comments
    @comment = Comment.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      flash[:success] = '投稿が送信されました'
      redirect_to user_path(current_user)
    else
      render 'events/new'
    end
  end

  def destroy
    @event.destroy
    flash[:success] = '投稿を削除しました'
    redirect_to request.referer || root_url
  end

  private

  def event_params
    params.require(:event).permit(:title, :content, :image)
  end

  def correct_user
    @event = current_user.evens.find_by(url_token: params[:url_token])
    redirect_to root_url if @event.nil?
  end
end

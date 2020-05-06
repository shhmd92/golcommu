class EventsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def new
    @event = current_user.events.build if user_signed_in?
  end

  def show
    @event = Event.find_by!(url_token: params[:url_token])
    @like = Like.new
    @comments = @event.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      flash[:notice] = 'イベントを作成しました'
      redirect_to event_path(@event)
    else
      render 'new'
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = 'イベントを削除しました'
    before_uri = URI.parse(request.referer)
    path = Rails.application.routes.recognize_path(before_uri.path)

    if path[:controller] == 'events'
      redirect_to root_path
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @event = Event.find_by(url_token: params[:url_token])
  end

  def update
    @event = Event.find_by(url_token: params[:url_token])
    if @event.update(event_params)
      flash[:notice] = 'イベントを更新しました'
      redirect_to event_path(@event)
    else
      render 'edit'
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :content, :maximum_participants, :image,
                                  :event_date, :start_time, :end_time)
  end

  def correct_user
    @event = current_user.events.find_by(url_token: params[:url_token])
    redirect_to root_url if @event.nil?
    end
end

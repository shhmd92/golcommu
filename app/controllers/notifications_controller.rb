class NotificationsController < ApplicationController
  MAX_PAGE = 20

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(MAX_PAGE)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end

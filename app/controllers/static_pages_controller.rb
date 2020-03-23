class StaticPagesController < ApplicationController
  def home
    @search = Event.ransack(params[:q])
    @events = @search.result.page(params[:page]).per(20)
  end
end

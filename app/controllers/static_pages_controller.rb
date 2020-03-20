class StaticPagesController < ApplicationController
  def home
    @events = Event.page(params[:page]).per(20)
  end
end

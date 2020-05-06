class StaticPagesController < ApplicationController
  MAX_PAGE = 20

  def home
    @events = Event.page(params[:page]).per(MAX_PAGE)
  end
end

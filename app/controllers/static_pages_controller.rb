class StaticPagesController < ApplicationController
  include CommonActions

  def home
    search_events
  end
end

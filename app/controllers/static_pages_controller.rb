class StaticPagesController < ApplicationController
  include CommonActions

  def home
    initial_search
  end
end

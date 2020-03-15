class StaticPagesController < ApplicationController
  def home
    @posts = Post.page(params[:page]).per(20)
  end
end

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def new
    @post = current_user.posts.build if user_signed_in?
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '投稿が送信されました'
      redirect_to user_path(current_user)
    else
      render 'posts/new'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '投稿を削除しました'
    redirect_to request.referer || root_url
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
    end
end

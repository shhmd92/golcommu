class LikesController < ApplicationController
  def create
    # @post = Post.find_by(url_token: params[:post_url_token])
    @like = current_user.likes.create(post_id: params[:post_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    # @post = Post.find_by(url_token: params[:post_url_token])
    @like = Like.find_by(post_id: params[:post_id], user_id: current_user.id)
    @like.destroy
    redirect_back(fallback_location: root_path)
  end
end

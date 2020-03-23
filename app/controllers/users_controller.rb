class UsersController < ApplicationController
  before_action :admin_user,     only: :destroy

  def index
    @search = User.ransack(params[:q])
    @users = @search.result.page(params[:page]).per(20)
  end

  def show
    @user = User.find_by!(url_token: params[:url_token])

    @events = @user.events.page(params[:page]).per(20)

    @following = @user.following.page(params[:page]).per(20)
    @followers = @user.followers.page(params[:page]).per(20)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'ユーザーは正常に削除されました'
    redirect_to users_url
  end

  private

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end

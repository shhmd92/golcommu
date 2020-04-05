class UsersController < ApplicationController
  before_action :admin_user,     only: :destroy

  def index
    @search_item_hash = { prefecture: 0, ages: 0, sex: 0, play_type: 0 }
    @users = User.where.not(admin: true, id: current_user.id).page(params[:page]).per(20)
  end

  def search
    prefecture = params[:prefecture_id].nil? ? params[:search_item_hash][:prefecture] : params[:prefecture_id]
    ages = params[:ages_id].nil? ? params[:search_item_hash][:ages] : params[:ages_id]
    sex = params[:sex_id].nil? ? params[:search_item_hash][:sex] : params[:sex_id]
    play_type = params[:play_type_id].nil? ? params[:search_item_hash][:play_type] : params[:play_type_id]

    query = 'SELECT * FROM users WHERE admin = :admin and id <> :user_id'
    query_hash = { admin: false, user_id: current_user.id }
    if prefecture.to_i.between?(1, User.prefectures.count)
      query += ' AND prefecture = :prefecture'
      query_hash[:prefecture] = prefecture
    end
    # if ages.to_i.between?(1, User.ages.count)
    #   query += ' AND birth_date = :sex'
    #   query_hash[:birth_date] = sex
    # end
    if sex.to_i.between?(1, User.sexes.count - 1)
      query += ' AND sex = :sex'
      query_hash[:sex] = sex
    end
    if play_type.to_i.between?(1, User.play_types.count)
      query += ' AND play_type = :play_type'
      query_hash[:play_type] = play_type
    end

    @users = User.find_by_sql([query, query_hash])
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(20)

    @search_item_hash = { prefecture: prefecture, ages: ages, sex: sex, play_type: play_type }
    render action: :index
  end

  def show
    @user = User.find_by!(username: params[:id])

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

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end

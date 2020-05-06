class UsersController < ApplicationController
  before_action :admin_user, only: :destroy

  def index
    @search_item_hash = { prefecture: 0, ages: 0, age_min: 0, age_max: 0, sex: 0, play_type: 0 }
    if user_signed_in?
      @users = User.where.not(admin: true, id: current_user.id).page(params[:page]).per(20)
    else
      @users = User.where.not(admin: true).page(params[:page]).per(20)
    end
  end

  def search
    # search conditions
    prefecture = params[:prefecture].nil? ? params[:search_item_hash][:prefecture] : params[:prefecture]
    ages = params[:ages].nil? ? params[:search_item_hash][:ages] : params[:ages]
    age_min = params[:age_min].nil? ? params[:search_item_hash][:age_min] : params[:age_min]
    age_max = params[:age_max].nil? ? params[:search_item_hash][:age_max] : params[:age_max]
    sex = params[:sex].nil? ? params[:search_item_hash][:sex] : params[:sex]
    play_type = params[:play_type].nil? ? params[:search_item_hash][:play_type] : params[:play_type]

    # Create SQL based on specified search conditions.
    if user_signed_in?
      query = 'SELECT * FROM users WHERE admin = :admin and id <> :user_id'
      query_hash = { admin: false, user_id: current_user.id }
    else
      query = 'SELECT * FROM users WHERE admin = :admin'
      query_hash = { admin: false }
    end
    if prefecture.to_i.between?(1, User.prefectures.count)
      query += ' AND prefecture = :prefecture'
      query_hash[:prefecture] = prefecture
    end
    if ages.to_i.between?(1, User.ages.count)
      birth_date_start = Date.today.prev_year(age_max.to_i)
      birth_date_end = Date.today.prev_year(age_min.to_i)

      query += ' AND birth_date >= :birth_date_start AND birth_date <= :birth_date_end'
      query_hash[:birth_date_start] = birth_date_start
      query_hash[:birth_date_end] = birth_date_end
    end
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

    # Refresh screen search conditions.
    @search_item_hash = { prefecture: prefecture, ages: ages, age_min: age_min, age_max: age_max,
                          sex: sex, play_type: play_type }
    render action: :index
  end

  def show
    @user = User.find_by!(url_token: params[:url_token])

    @events = @user.events.order(event_date: :desc).page(params[:page]).per(20)
    @participated_events = @user.participated_events.order(event_date: :desc).page(params[:page]).per(20)
    @liked_events = @user.liked_events.order(event_date: :desc).page(params[:page]).per(20)

    @following = @user.following.page(params[:page]).per(20)
    @followers = @user.followers.page(params[:page]).per(20)
  end

  def destroy
    User.find_by!(url_token: params[:url_token]).destroy
    flash[:notice] = 'ユーザーは正常に削除されました'
    redirect_to users_path
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end

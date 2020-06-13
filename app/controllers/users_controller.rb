class UsersController < ApplicationController
  before_action :admin_user, only: :destroy

  MAX_PAGE = 20

  def index
    @search_item_hash = { prefecture_id: 0, ages: 0, age_min: 0, age_max: 0, sex: 0, play_type: 0 }
    # ログインしている場合はログインユーザーを検索結果に含めない
    @users = if user_signed_in?
               User.where.not(admin: true, id: current_user.id)
             else
               User.where.not(admin: true)
             end
    pagination_users(@users)
  end

  def search
    # 画面の各種検索条件を取得する
    search_item_hash = if params[:search_item_hash].is_a?(String)
                         JSON.parse(params[:search_item_hash])
                       else
                         params[:search_item_hash].permit!.to_h
                       end
    prefecture_id = params[:prefecture_id] || search_item_hash['prefecture_id']
    ages = params[:ages] || search_item_hash['ages']
    age_min = params[:age_min] || search_item_hash['age_min']
    age_max = params[:age_max] || search_item_hash['age_max']
    sex = params[:sex] || search_item_hash['sex']
    play_type = params[:play_type] || search_item_hash['play_type']

    # 検索条件の設定
    conditions = [
      { admin: false }
    ]

    # 都道府県
    if prefecture_id.to_i.between?(1, Prefecture.count)
      conditions.push(
        { prefecture_id: prefecture_id }
      )
    end

    # 年代
    if ages.to_i.between?(1, User.ages.count)
      birth_date_start = Date.today.prev_year(age_max.to_i)
      birth_date_end = Date.today.prev_year(age_min.to_i)

      conditions.push(
        { birth_date: birth_date_start..birth_date_end }
      )
    end

    # 性別
    if sex.to_i.between?(1, User.sexes.count - 1)
      conditions.push(
        { sex: sex }
      )
    end

    # プレータイプ
    if play_type.to_i.between?(1, User.play_types.count)
      conditions.push(
        { play_type: play_type }
      )
    end

    users = conditions.inject(User, &:where)

    # ログインユーザーは除外する
    users.where.not(id: current_user.id) if user_signed_in?

    @users = users

    pagination_users(@users)

    # 画面の検索条件を更新する
    @search_item_hash = { prefecture_id: prefecture_id, ages: ages, age_min: age_min, age_max: age_max,
                          sex: sex, play_type: play_type }
    render action: :index
  end

  def show
    find_user

    @events = @user.events.order(event_date: :desc).page(params[:event_page]).per(MAX_PAGE)
    @participated_events = @user.participated_events.order(event_date: :desc).page(params[:participated_event_page]).per(MAX_PAGE)
    @liked_events = @user.liked_events.order(event_date: :desc).page(params[:liked_event_page]).per(MAX_PAGE)
  end

  def following
    find_user

    @following = @user.following.page(params[:page]).per(MAX_PAGE)
  end

  def followers
    find_user

    @followers = @user.followers.page(params[:page]).per(MAX_PAGE)
  end

  def destroy
    find_user.destroy
    flash[:notice] = 'ユーザーは正常に削除されました'
    redirect_to users_path
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def find_user
    @user = User.find_by!(url_token: params[:url_token])
  end

  def pagination_users(users)
    # 検索結果の件数を設定
    @user_count = users.count
    # ページネーション
    @users = Kaminari.paginate_array(users).page(params[:page]).per(MAX_PAGE)
  end
end

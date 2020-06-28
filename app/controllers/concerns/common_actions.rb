module CommonActions
  extend ActiveSupport::Concern

  MAX_PAGE = 20
  INITIAL_SEARCH = 1

  def search_events
    common_search(nil)
  end

  def initial_search
    common_search(INITIAL_SEARCH)
  end

  private

  def common_search(search_mode)
    @q = Event.ransack(params[:q])
    @q.sorts = 'event_date desc' if @q.sorts.empty?
    @events = @q.result(distinct: true).includes(:user)
    # 初期表示時はシステム日付以降のイベントのみ表示する
    if search_mode == INITIAL_SEARCH
      @events = @events.where(event_date: Date.today..Float::INFINITY)
    end
    @event_count = @events.count
    @events = @events.page(params[:page]).per(MAX_PAGE)
  end
end

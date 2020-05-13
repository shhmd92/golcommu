module CommonActions
  extend ActiveSupport::Concern

  MAX_PAGE = 20

  def search_events
    @q = Event.ransack(params[:q])
    @q.sorts = 'event_date desc' if @q.sorts.empty?
    @events = @q.result(distinct: true).includes(:user)
    @event_count = @events.count
    @events = @events.page(params[:page]).per(MAX_PAGE)
  end
end

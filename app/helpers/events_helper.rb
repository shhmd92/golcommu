module EventsHelper
  def date_wday(date)
    date.to_s + '(' + %w[日 月 火 水 木 金 土][date.wday] + ')'
  end

  def format_time(time)
    time.strftime("%H:%M")
  end
end

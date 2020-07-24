namespace :create_notification do
  desc 'イベント終了通知の作成'
  task create_event_close_notification: :environment do
    logger = Logger.new 'log/create_notification.log'

    # イベント終了通知未作成のイベントを取得
    uncreated_notification_events =
      Event.joins("LEFT JOIN notifications ON events.id = notifications.event_id AND action = '#{Event::CLOSE_ACTION}'")
           .where('events.event_date < ?', Date.today)
           .where(notifications: { id: nil })

    uncreated_notification_events.find_each do |event|
      # 主催者以外の参加者に対して終了通知を作成
      event.participants.each do |participant|
        next unless event.user_id != participant.user_id

        notificaton = Notification.new(
          visitor_id: event.user_id,
          visited_id: participant.user_id,
          event_id: event.id,
          action: Event::CLOSE_ACTION
        )
        notificaton.save!
      end
    rescue StandardError => e
      logger.error "event_id: #{event.id}でエラーが発生"
      logger.error e
      logger.error e.backtrace.join("\n")
      next
    end
  end
end

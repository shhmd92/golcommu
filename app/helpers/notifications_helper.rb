module NotificationsHelper
  def notification_form(notification)
    @comment = nil
    @event = nil

    visitor = link_to(notification.visitor.username,
                      user_path(notification.visitor),
                      style: 'font-weight: bold;')

    notificated_event = ''
    unless notification.event.nil?
      @event = notification.event
      event_name = if notification.event.user_id == current_user.id
                     'あなたのイベント'
                   else
                     notification.event.user.username + 'さんのイベント'
                   end
      event_name << "(#{date_wday(notification.event.event_date)})"
      notificated_event = link_to(event_name,
                                  event_path(notification.event),
                                  style: 'font-weight: bold;')
    end

    case notification.action
    when User::FOLLOW_ACTION
      "#{visitor}さんがあなたをフォローしました"
    when Event::LIKE_ACTION
      "#{visitor}さんが#{notificated_event}を気になるイベントにしました"
    when Event::COMMENT_ACTION
      @comment = Comment.find_by(id: notification.comment_id)&.content
      "#{visitor}さんが#{notificated_event}にコメントしました"
    when Event::PARTICIPATE_ACTION
      "#{visitor}さんが#{notificated_event}に参加しました"
    when Event::INVITE_ACTION
      @event_invitation = EventInvitation.search_invitation(notification.event_id, notification.visited_id)
      "#{notificated_event}に招待されました"
    when Event::CLOSE_ACTION
      "#{notificated_event}はいかかでしたか？"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end

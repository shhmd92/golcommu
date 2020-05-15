module NotificationsHelper
  def notification_form(notification)
    @comment = nil

    visitor = link_to(notification.visitor.username,
                      user_path(notification.visitor),
                      style: 'font-weight: bold;')
    your_event = link_to('あなたのイベント',
                          event_path(notification.event),
                          style: 'font-weight: bold;')

    case notification.action
    when 'follow'
      "#{visitor}さんがあなたをフォローしました"
    when 'like'
      "#{visitor}さんが#{your_event}を気になるイベントにしました"
    when 'comment' then
      @comment = Comment.find_by(id: notification.comment_id)&.content
      "#{visitor}さんが#{your_event}にコメントしました"
    when 'participate'
      "#{visitor}さんが#{your_event}に参加しました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end

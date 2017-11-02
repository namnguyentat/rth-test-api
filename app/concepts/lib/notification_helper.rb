module NotificationHelper
  def create_notification(owner:, actor:, resource:, action:, data: nil, kind: nil)
    if owner != actor
      Notification.create!(
        user: owner,
        actor: actor,
        resource: resource,
        action: action,
        data: data || '{}',
        kind: kind || 'normal'
      )
    end
  end

  def increase_unseen_notification_count(notification)
    return if notification.nil?
    notification.user.increment!(:unseen_notification_count)
  end

  def send_notification(notification)
    NotificationService.new(notification).call if notification.present?
  end
end

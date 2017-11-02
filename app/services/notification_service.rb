class NotificationService
  def initialize(notification)
    raise ArgumentError if notification.nil?
    @notification = notification
  end

  def call
    if @notification.user.notification_mode == 'all'
      NotificationMailer.notification_email(@notification).deliver_later
    end
  end
end

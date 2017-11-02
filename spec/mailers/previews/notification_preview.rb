# Preview all emails at http://localhost:30001/rails/mailers/notification
class NotificationPreview < ActionMailer::Preview
  # Preview this email at http://localhost:30001/rails/mailers/notification/notification_email
  def notification_email
    NotificationMailer.notification_email
  end
end

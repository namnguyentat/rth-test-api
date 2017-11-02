namespace :mailer do
  namespace :test do
    task notifications: :environment do
      return if User.count.zero?

      from_user = User.first
      to_user = User.last
      to_user.email = ENV['DEVELOPER_EMAIL']
      resource = Post.first

      Notification.actions.each do |key, _|
        notification = Notification.new(user: to_user, actor: from_user, resource: resource, action: key)
        NotificationMailer.notification_email(notification).deliver_now
      end
    end
  end
end

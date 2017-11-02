namespace :db do
  namespace :sanitize do
    task notifications: :environment do
      count = 0
      Notification.all.each do |notification|
        if !User.exists?(id: notification.actor) ||
          (notification.resource.is_a?(Post) && !Post.exists?(notification.resource)) ||
          (notification.resource.is_a?(User) && !User.exists?(notification.resource))
          notification.destroy
          count += 1
        end
      end
      puts "#{count} notifications destroyed"
    end
  end
end

namespace :db do
  namespace :fake do
    desc 'create sample notifications'
    task notifications: :environment do
      ActiveRecord::Base.transaction do
        Reply.all.each do |reply|
          Notification.status_new.create!(
            user: reply.comment.user,
            actor: reply.user,
            resource: reply,
            action: 'reply_comment'
          )
        end
      end

      ActiveRecord::Base.transaction do
        Follow.all.each do |follow|
          next unless follow.followable.is_a?(User)

          Notification.status_new.create!(
            user: follow.followable,
            actor: follow.user,
            resource: follow.followable,
            action: "follow_#{follow.followable.class.name.downcase}"
          )
        end
      end

      ActiveRecord::Base.transaction do
        Upvote.where(upvotable_type: 'Comment').all.each do |upvote|
          Notification.status_new.create!(
            user: upvote.upvotable.user,
            actor: upvote.user,
            resource: upvote.upvotable,
            action: "upvote_#{upvote.upvotable.class.name.downcase}"
          )
        end
      end

      puts "#{Notification.count} notifications created"
    end
  end
end

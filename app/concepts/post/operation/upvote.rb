module Post::Operation
  class Upvote < ApplicationOperation
    include NotificationHelper

    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Macros::FindModel(model: Post, key: 'id')
      step :create_upvote!
      step Wrap(StepWrapper::Transaction) {
        success :increase_like_count!
        success :create_notification!
        success :increase_unseen_notification_count!
      }
      # success :send_notification!
      failure :error!
    }

    def create_upvote!(options, current_user:, **)
      options['model'].upvoters << current_user
    end

    def increase_like_count!(options, **)
      options['model'].user.increment!(:like_count)
    end

    def create_notification!(options, current_user:, **)
      options['my.notification'] = create_notification(
        owner: options['model'].user,
        actor: current_user,
        resource: options['model'],
        action: Notification.actions[:upvote_post],
      )
    end

    # def send_notification!(options, **)
    #   send_notification(options['my.notification'])
    # end

    def increase_unseen_notification_count!(options, **)
      increase_unseen_notification_count(options['my.notification'])
    end
  end
end

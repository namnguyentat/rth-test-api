module User::Operation
  class Follow < ApplicationOperation
    include NotificationHelper

    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Macros::FindModel(model: User, key: 'id')
      step :check_with_current_user!
      step :create_follow!
      step Wrap(StepWrapper::Transaction) {
        success :create_notification!
        success :increase_unseen_notification_count!
      }
      # success :send_notification!
      failure :error!
    }

    def check_with_current_user!(options, current_user:, **)
      if options['model'].id == current_user.id
        raise ActionController::BadRequest, 'User cannot follow himself / herself'
      end
      true
    end

    def create_follow!(options, current_user:, **)
      options['model'].followers << current_user
    end

    def create_notification!(options, current_user:, **)
      options['my.notification'] = create_notification(
        owner: options['model'],
        actor: current_user,
        resource: options['model'],
        action: Notification.actions[:follow_user],
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

module Reply::Operation
  class Create < ApplicationOperation
    include NotificationHelper

    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Model(Reply, :new)
      step Contract::Build(constant: Reply::Contract::Create, builder: :default_contract!)
      step Contract::Validate()
      failure Macros::AssignValidationError()
      step Contract::Persist()
      step Wrap(StepWrapper::Transaction) {
        success :create_notification!
        success :increase_unseen_notification_count!
      }
      # success :send_notification!
      failure :error!
    }

    def default_contract!(options, constant:, model:, **)
      constant.new(model, user_id: options[:current_user].id)
    end

    def create_notification!(options, **)
      options['my.notification'] = create_notification(
        owner: options['model'].comment.user,
        actor: options['model'].user,
        resource: options['model'],
        action: Notification.actions[:reply_comment]
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

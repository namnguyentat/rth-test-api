module Notification::Operation
  class ClearUnseen < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step :clear_unseen!
      failure :error!
    }

    def clear_unseen!(options, current_user:, **)
      current_user.update!(unseen_notification_count: 0)
    end
  end
end

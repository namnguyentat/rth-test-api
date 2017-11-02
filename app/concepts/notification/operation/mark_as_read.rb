module Notification::Operation
  class MarkAsRead < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step :mark_as_read!
      failure :error!
    }

    def mark_as_read!(options, current_user:, **)
      current_user.notifications.status_new.update_all(status: Notification.statuses[:read])
    end
  end
end

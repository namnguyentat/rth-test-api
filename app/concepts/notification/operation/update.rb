module Notification::Operation
  class Update < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Macros::FindModel(model: Notification, key: 'id')
      step Macros::Authorize(Notification::Policy::Authorization, :update?)
      step :update_status!
      failure :error!
    }

    def update_status!(options, **)
      options['model'].status_read!
    end
  end
end

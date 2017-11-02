module User::Operation
  class Unfollow < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Macros::FindModel(model: User, key: 'id')
      step :destroy_follow!
      failure :error!
    }

    def destroy_follow!(options, current_user:, **)
      options['model'].followers.destroy(current_user)
    end
  end
end

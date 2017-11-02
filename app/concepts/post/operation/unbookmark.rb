module Post::Operation
  class Unbookmark < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Macros::FindModel(model: Post, key: 'id')
      step :destroy_bookmark!
      failure :error!
    }

    def destroy_bookmark!(options, current_user:, **)
      options['model'].bookmarkers.destroy(current_user)
    end
  end
end

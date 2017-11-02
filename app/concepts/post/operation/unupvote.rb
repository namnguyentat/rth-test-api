module Post::Operation
  class Unupvote < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Macros::FindModel(model: Post, key: 'id')
      step :destroy_upvote!
      failure :error!
    }

    def destroy_upvote!(options, current_user:, **)
      options['model'].upvoters.destroy(current_user)
    end
  end
end

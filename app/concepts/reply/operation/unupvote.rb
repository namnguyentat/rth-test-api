module Reply::Operation
  class Unupvote < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Macros::FindModel(model: Reply, key: 'id')
      step Wrap(StepWrapper::Transaction) {
        step :destroy_upvote!
        step :decrease_like_count!
      }
      failure :error!
    }

    def destroy_upvote!(options, current_user:, **)
      options['model'].upvoters.destroy(current_user)
    end

    def decrease_like_count!(options, **)
      options['model'].user.decrement!(:like_count)
    end
  end
end

module Comment::Operation
  class Destroy < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Macros::FindModel(model: Comment, key: 'id')
      step Macros::Authorize(Comment::Policy::Authorization, :destroy?)
      step Macros::DestroyModel()
      failure :error!
    }
  end
end

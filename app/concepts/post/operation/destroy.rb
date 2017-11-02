module Post::Operation
  class Destroy < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Macros::FindModel(model: Post, key: 'id')
      step Macros::Authorize(Post::Policy::Authorization, :destroy?)
      step Macros::DestroyModel()
      failure :error!
    }
  end
end

module Reply::Operation
  class Destroy < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Macros::FindModel(model: Reply, key: 'id')
      step Macros::Authorize(Reply::Policy::Authorization, :destroy?)
      step Macros::DestroyModel()
      failure :error!
    }
  end
end

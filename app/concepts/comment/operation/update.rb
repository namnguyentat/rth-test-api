module Comment::Operation
  class Update < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Macros::FindModel(model: Comment, key: 'id')
      step Macros::Authorize(Comment::Policy::Authorization, :update?)
      step Contract::Build(constant: Comment::Contract::Update)
      step Contract::Validate()
      failure Macros::AssignValidationError()
      step Contract::Persist()
      failure :error!
    }
  end
end

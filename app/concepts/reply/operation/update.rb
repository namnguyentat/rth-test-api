module Reply::Operation
  class Update < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Macros::FindModel(model: Reply, key: 'id')
      step Macros::Authorize(Reply::Policy::Authorization, :update?)
      step Contract::Build(constant: Reply::Contract::Update)
      step Contract::Validate()
      failure Macros::AssignValidationError()
      step Contract::Persist()
      failure :error!
    }
  end
end

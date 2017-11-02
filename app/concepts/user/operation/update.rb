module User::Operation
  class Update < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step :set_model!
      step Contract::Build(constant: User::Contract::Update)
      step Contract::Validate()
      failure Macros::AssignValidationError()
      step Contract::Persist()
      failure :error!
    }

    def set_model!(options, current_user:, **)
      options['model'] = current_user
      true
    end
  end
end

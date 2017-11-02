module Feedback::Operation
  class Create < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Model(Feedback, :new)
      step Contract::Build(constant: Feedback::Contract::Create, builder: :default_contract!)
      step Contract::Validate()
      failure Macros::AssignValidationError()
      step Contract::Persist()
      failure :error!
    }

    def default_contract!(options, constant:, model:, **)
      constant.new(model, user_id: options[:current_user].nil? ? nil : options[:current_user].id)
    end
  end
end

module Post::Operation
  class Create < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Model(Post, :new)
      step Contract::Build(constant: Post::Contract::Create, builder: :default_contract!)
      step Contract::Validate()
      failure Macros::AssignValidationError()
      step Contract::Persist()
      failure :error!
    }

    def default_contract!(options, constant:, model:, **)
      constant.new(model, user_id: options[:current_user].id)
    end
  end
end

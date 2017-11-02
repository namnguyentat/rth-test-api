module Post::Operation
  class CreateComment < ApplicationOperation
    include NotificationHelper

    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Model(Comment, :new)
      step Contract::Build(constant: Post::Contract::CreateComment, builder: :default_contract!)
      step Contract::Validate()
      failure Macros::AssignValidationError()
      step Contract::Persist()
      failure :error!
    }

    def default_contract!(options, constant:, model:, **)
      constant.new(model, user_id: options[:current_user].id, commentable_type: 'Post')
    end
  end
end

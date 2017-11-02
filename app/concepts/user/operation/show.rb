module User::Operation
  class Show < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step :find_user!
      step Macros::Authorize(User::Policy::Authorization, :show?)
    }

    def find_user!(options, params:, **)
      options['model'] = User.find_by(id: params[:id])
    end
  end
end

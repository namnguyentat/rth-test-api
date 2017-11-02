module User::Operation
  class CompleteOnboarding < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step :set_model!
      step :update_onboarding!
      failure :error!
    }

    def set_model!(options, current_user:, **)
      options['model'] = current_user
      true
    end

    def update_onboarding!(options, **)
      options['model'].update_attributes(onboarding: 'completed')
    end
  end
end

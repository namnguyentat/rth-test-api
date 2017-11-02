module Session::Operation
  class Destroy < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step :destroy_session!
      failure :error!
    }

    def destroy_session!(options, params:, current_user:, **)
      current_user.sessions.find_by(access_token: params['access_token']).try(:destroy)
    end
  end
end

module Session::Operation
  class CreateWithGoogle < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step :get_user_info_from_google!
      step :build_user!
      step :update_user_info!
      step :create_session!
      failure :error!
    }

    def get_user_info_from_google!(options, params:, **)
      options['my.user_info'] = GoogleApiService.new(params['oauth_access_token']).get_user_info
      options['my.user_info'] && options['my.user_info']['id']
    end

    def build_user!(options, **)
      options['my.user'] = User.find_by(google_id: options['my.user_info']['id'])

      if options['my.user'].nil? && options['my.user_info']['email'].present?
        options['my.user'] = User.find_by(email: options['my.user_info']['email'])
      end

      options['my.user'] ||= User.new
    end

    def update_user_info!(options, **)
      info = options['my.user_info']
      user = options['my.user']

      if user.new_record?
        user.onboarding = 'completed'
        user.avatar = info['picture']
        user.name = info['name']
      end

      user.google_id = info['id']
      user.email = info['email'] if info['email'].present?

      user.save!
    end

    def create_session!(options, **)
      token = SecureRandom.hex(64)
      options['model'] = options['my.user'].sessions.create!(access_token: token, expires_at: 6.months.from_now)
    end
  end
end

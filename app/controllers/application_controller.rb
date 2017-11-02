class ApplicationController < ActionController::API
  include ErrorHandler

  attr_reader :current_user

  prepend_before_action :get_current_user

  def access_token
    # remove prefix "Bearer "
    @access_token ||= request.headers['Authorization'].try(:[], 7..-1)
  end

  def get_current_user
    @current_user = access_token.present? ? Session.user_from_access_token(access_token) : nil
  end

  # For lograge
  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user.id if current_user
    payload[:remote_ip] = remote_ip(request)
  end

  private

  def remote_ip(request)
    request.headers['HTTP_X_REAL_IP'] || request.remote_ip
  end
end

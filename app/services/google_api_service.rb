class GoogleApiService
  attr_reader :oauth_access_token, :graph

  def initialize(oauth_access_token)
    @oauth_access_token = oauth_access_token
  end

  def get_user_info
    response = Faraday.get "https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{@oauth_access_token}"
    JSON.parse(response.body)
  end
end

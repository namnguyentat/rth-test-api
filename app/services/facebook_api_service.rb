class FacebookApiService
  attr_reader :oauth_access_token, :graph

  def initialize(oauth_access_token)
    @oauth_access_token = oauth_access_token
    @graph = Koala::Facebook::API.new(oauth_access_token)
  end

  def get_user_info
    graph
      .get_object('me?fields=id,name,email,picture.width(160).height(160),about,friends')
      .merge!('facebook_oauth_access_token' => oauth_access_token)
  end
end

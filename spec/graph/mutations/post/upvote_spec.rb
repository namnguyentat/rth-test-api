require 'rails_helper'

RSpec.describe 'UpvotePost', type: :graph do
  it_behaves_like 'Upvotatable', Post
end

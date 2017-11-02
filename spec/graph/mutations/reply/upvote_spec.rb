require 'rails_helper'

RSpec.describe 'UpvoteReply', type: :graph do
  it_behaves_like 'Upvotatable', Reply
end

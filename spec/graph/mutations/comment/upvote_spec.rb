require 'rails_helper'

RSpec.describe 'UpvoteComment', type: :graph do
  it_behaves_like 'Upvotatable', Comment
end

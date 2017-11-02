require 'rails_helper'

RSpec.describe 'UnupvotePost', type: :graph do
  it_behaves_like 'Unupvotatable', Post
end

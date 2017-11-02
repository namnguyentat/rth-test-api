require 'rails_helper'

RSpec.describe 'UnfollowUser', type: :graph do
  it_behaves_like 'Unfollowable', User
end

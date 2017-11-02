require 'rails_helper'

RSpec.describe 'FollowUser', type: :graph do
  it_behaves_like 'Followable', User
end

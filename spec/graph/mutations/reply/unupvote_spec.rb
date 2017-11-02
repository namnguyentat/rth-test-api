require 'rails_helper'

RSpec.describe 'UnupvoteReply', type: :graph do
  it_behaves_like 'Unupvotatable', Reply
end

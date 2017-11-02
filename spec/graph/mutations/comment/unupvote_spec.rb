require 'rails_helper'

RSpec.describe 'UnupvoteComment', type: :graph do
  it_behaves_like 'Unupvotatable', Comment
end

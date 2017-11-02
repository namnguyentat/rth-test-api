require 'rails_helper'

RSpec.describe 'UnbookmarkPost', type: :graph do
  it_behaves_like 'Unbookmarkable', Post
end

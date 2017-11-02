require 'rails_helper'

RSpec.describe 'BookmarkPost', type: :graph do
  it_behaves_like 'Bookmarkable', Post
end

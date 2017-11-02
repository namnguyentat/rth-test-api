require 'rails_helper'

RSpec.describe Session, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:access_token) }
end

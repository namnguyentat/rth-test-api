require 'rails_helper'

RSpec.describe Follow, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:followable_id) }
  it { should validate_presence_of(:followable_type) }

  it "validate uniqueness of [user, followable]" do
    follow = create(:follow)
    expect {
      Follow.create!(user: follow.user, followable: follow.followable)
    }.to raise_error ActiveRecord::RecordInvalid
  end
end

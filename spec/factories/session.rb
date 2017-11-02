FactoryGirl.define do
  factory :session do
    user
    sequence(:access_token) { |n| "_sample_access_token_#{n}" }
    expires_at DateTime.new(2500, 2, 3, 4, 5, 6)
  end
end

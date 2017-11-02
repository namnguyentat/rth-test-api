FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User name #{n}" }
    sequence(:about) { |n| "User about #{n}" }
    avatar 'faker_photo.jpg'
    onboarding 'completed'
    unseen_notification_count 0
  end
end

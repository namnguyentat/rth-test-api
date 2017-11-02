FactoryGirl.define do
  factory :follow do
    user
    followable { |resource| resource.association(:user) }

    trait :user_follow do
      association :followable, factory: :user
    end

    trait :topic_follow do
      association :followable, factory: :topic
    end
  end
end

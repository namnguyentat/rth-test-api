FactoryGirl.define do
  factory :upvote do
    user
    upvotable { |resource| resource.association(:comment) }

    trait :post_upvote do
      association :upvotable, factory: :post
    end
  end
end

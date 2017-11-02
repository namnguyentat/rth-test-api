FactoryGirl.define do
  factory :notification do
    user
    status Notification.statuses[:new]
    action 'comment_post'
    data nil

    association :actor, factory: :user

    resource { |res| res.association(:post) }

    trait :post_resource do
      association :resource, factory: :post
    end

    trait :comment_resource do
      association :resource, factory: :comment
    end
  end
end

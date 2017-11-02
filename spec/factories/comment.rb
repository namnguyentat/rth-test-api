FactoryGirl.define do
  factory :comment do
    user
    commentable { |resource| resource.association(:post) }
    sequence(:content) { |n| "Comment content #{n}" }
    report_count 0
    upvote_count 0

    trait :post_comment do
      association :commentable, factory: :post
    end
  end
end

FactoryGirl.define do
  factory :reply do
    user
    comment
    sequence(:content) { |n| "Reply content #{n}" }
    report_count 0
    upvote_count 0
  end
end

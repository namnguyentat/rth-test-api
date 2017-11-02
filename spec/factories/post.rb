FactoryGirl.define do
  factory :post do
    user

    sequence(:title) { |n| "Post title #{n}" }
    sequence(:image) { |n| "http://example.com/images/#{n}.jpg" }
    sequence(:content) { |n| "Post content #{n}" }

    bookmark_count 0
    report_count 0
    upvote_count 0
    view_count 0

    after(:create) do |post|
      post.update!(content: generate_content_state(post.content))
    end
  end
end

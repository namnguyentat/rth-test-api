module Types
  UserType = User.to_graphql_type(
    fields: [
      :avatar,
      :email,
      :name,
      :slug,
      :about,
      :company,
      :job,
      :follower_count,
      :following_user_count,
      :post_count,
      :comment_count,
      :reply_count,
      :like_count,
      :bookmark_post_count,
      :unseen_notification_count,
    ],
    relay: true
  ) do |obj|
    obj.field :notification_mode, !obj.types.String
    obj.field :onboarding, !obj.types.String
    obj.field :followed, Fields::FollowedField
    obj.connection :bookmarked_posts, Fields::BookmarkedPostsField, max_page_size: Settings.graph.max_page_size
    obj.connection :posts, Fields::PostsField, max_page_size: Settings.graph.max_page_size
    obj.connection :followers, Fields::FollowersField, max_page_size: Settings.graph.max_page_size
    obj.connection :following_users, Fields::FollowingUsersField, max_page_size: Settings.graph.max_page_size
    obj.connection :notifications, Fields::NotificationsField, max_page_size: Settings.graph.max_page_size
    obj.connection :comments, Fields::UserCommentsField, max_page_size: Settings.graph.max_page_size
  end
end

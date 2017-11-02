module Types
  CommentType = Comment.to_graphql_type(
    fields: [
      :content,
      :created_at,
      :upvote_count,
      :reply_count
    ],
    relay: true
  ) do |obj|
    obj.field :commentable, Fields::CommentableField
    obj.field :user, Fields::UserField

    obj.field :upvoted, Fields::UpvotedField

    obj.connection :replies, Fields::RepliesField, max_page_size: Settings.graph.max_page_size
  end
end

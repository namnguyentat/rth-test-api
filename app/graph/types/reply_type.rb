module Types
  ReplyType = Reply.to_graphql_type(
    fields: [
      :content,
      :created_at,
      :upvote_count
    ],
    relay: true
  ) do |obj|
    obj.field :comment, Fields::CommentField
    obj.field :user, Fields::UserField
    obj.field :upvoted, Fields::UpvotedField
  end
end

module Types
  NotificationResourceType = GraphQL::UnionType.define do
    name "NotificationResource"
    description "Post | Comment | Reply | User"
    possible_types [
      Types::PostType,
      Types::CommentType,
      Types::ReplyType,
      Types::UserType
    ]
  end
end

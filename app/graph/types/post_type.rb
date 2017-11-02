module Types
  PostType = GraphQL::ObjectType.define do
    interfaces [GraphQL::Relay::Node.interface, Types::Interface::CommentableInterface]

    name 'Post'
    description 'post'

    field :title, types.String
    field :image, types.String
    field :content, types.String
    field :created_at, types.String
    field :upvote_count, types.Int
    field :view_count, types.Int

    field :bookmarked, Fields::BookmarkedField
    field :upvoted, Fields::UpvotedField
  end
end

module Types
  QueryType = GraphQL::ObjectType.define do
    name 'Query'
    description 'The query root for the schema'

    field :node, GraphQL::Relay::Node.field
    field :nodes, GraphQL::Relay::Node.plural_field

    field :post, Fields::EntryPoint::PostField
    field :comment, field: Fields::EntryPoint::CommentField
    field :user, field: Fields::EntryPoint::UserField
    field :viewer, Fields::EntryPoint::ViewerField
  end
end

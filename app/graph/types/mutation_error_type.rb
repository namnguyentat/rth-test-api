module Types
  MutationErrorType = GraphQL::ObjectType.define do
    name 'MutationError'
    description 'mutation error'

    field :code, types.Int
    field :message, types.String
  end
end

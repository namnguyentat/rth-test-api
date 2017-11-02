module Types
  MutationResultType = GraphQL::ObjectType.define do
    name 'MutationResult'
    description 'mutation result'

    field :success, !types.Boolean
    field :error, Types::MutationErrorType
  end
end

module Mutations
  module SessionMutation
    Destroy = GraphQL::Relay::Mutation.define do
      name 'DestroySession'

      input_field :access_token, !types.ID

      return_field :ret, !Types::MutationResultType

      resolve ->(_obj, inputs, ctx) do
        result = Session::Operation::Destroy.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        {
          ret: MutationResult.new(result)
        }
      end
    end
  end
end

module Mutations
  module UserMutation
    FollowMultiple = GraphQL::Relay::Mutation.define do
      name 'FollowMultipleUser'

      input_field :ids, !types[Types::Input::GlobalIdInput]

      return_field :ret, !Types::MutationResultType

      resolve ->(_obj, inputs, ctx) do
        result = User::Operation::FollowMultiple.(
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

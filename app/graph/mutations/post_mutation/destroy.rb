module Mutations
  module PostMutation
    Destroy = GraphQL::Relay::Mutation.define do
      name 'DestroyPost'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = Post::Operation::Destroy.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          current_user = ctx[:current_user].reload
        else
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          current_user: current_user
        }
      end
    end
  end
end

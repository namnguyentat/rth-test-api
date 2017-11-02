module Mutations
  module PostMutation
    Unbookmark = GraphQL::Relay::Mutation.define do
      name 'UnbookmarkPost'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :post, Types::PostType
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = Post::Operation::Unbookmark.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          post = result['model']
          current_user = ctx[:current_user].reload
        else
          post = nil
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          post: post,
          current_user: current_user
        }
      end
    end
  end
end

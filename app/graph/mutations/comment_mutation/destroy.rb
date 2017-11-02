module Mutations
  module CommentMutation
    Destroy = GraphQL::Relay::Mutation.define do
      name 'DestroyComment'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :commentable, Types::Interface::CommentableInterface

      resolve ->(_obj, inputs, ctx) do
        result = Comment::Operation::Destroy.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          commentable = result['model'].commentable
        else
          commentable = nil
        end

        {
          ret: MutationResult.new(result),
          commentable: commentable
        }
      end
    end
  end
end

module Mutations
  module CommentMutation
    Unupvote = GraphQL::Relay::Mutation.define do
      name 'UnupvoteComment'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :comment, Types::CommentType

      resolve ->(_obj, inputs, ctx) do
        result = Comment::Operation::Unupvote.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          comment = result['model'].reload_attribute(:upvote_count)
        else
          comment = nil
        end

        {
          ret: MutationResult.new(result),
          comment: comment
        }
      end
    end
  end
end

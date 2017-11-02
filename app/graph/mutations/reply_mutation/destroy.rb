module Mutations
  module ReplyMutation
    Destroy = GraphQL::Relay::Mutation.define do
      name 'DestroyReply'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :comment, Types::CommentType

      resolve ->(_obj, inputs, ctx) do
        result = Reply::Operation::Destroy.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          comment = result['model'].comment
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

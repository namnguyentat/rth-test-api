module Mutations
  module ReplyMutation
    Unupvote = GraphQL::Relay::Mutation.define do
      name 'UnupvoteReply'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :reply, Types::ReplyType

      resolve ->(_obj, inputs, ctx) do
        result = Reply::Operation::Unupvote.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          reply = result['model'].reload_attribute(:upvote_count)
        else
          reply = nil
        end

        {
          ret: MutationResult.new(result),
          reply: reply
        }
      end
    end
  end
end

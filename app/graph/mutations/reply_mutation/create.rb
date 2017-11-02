module Mutations
  module ReplyMutation
    Create = GraphQL::Relay::Mutation.define do
      name 'CreateReply'

      input_field :comment_id, !Types::Input::GlobalIdInput
      input_field :content, !types.String

      return_field :ret, !Types::MutationResultType
      return_field :reply_edge, Types::ReplyType.edge_type
      return_field :comment, Types::CommentType

      resolve ->(_obj, inputs, ctx) do
        result = Reply::Operation::Create.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          reply_connection = GraphQL::Relay::RelationConnection.new(Reply.all, {})
          reply_edge = GraphQL::Relay::Edge.new(result['model'], reply_connection)
          comment = result['model'].comment
        else
          reply_edge = nil
        end

        {
          ret: MutationResult.new(result),
          reply_edge: reply_edge,
          comment: comment
        }
      end
    end
  end
end

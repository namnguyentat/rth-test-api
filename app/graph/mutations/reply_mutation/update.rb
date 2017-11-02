module Mutations
  module ReplyMutation
    Update = GraphQL::Relay::Mutation.define do
      name 'UpdateReply'

      input_field :id, !Types::Input::GlobalIdInput
      input_field :content, !types.String

      return_field :ret, !Types::MutationResultType
      return_field :reply, Types::ReplyType

      resolve ->(_obj, inputs, ctx) do
        result = Reply::Operation::Update.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          reply = result['model']
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

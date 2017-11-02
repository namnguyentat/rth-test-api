module Mutations
  module CommentMutation
    Update = GraphQL::Relay::Mutation.define do
      name 'UpdateComment'

      input_field :id, !Types::Input::GlobalIdInput
      input_field :content, !types.String

      return_field :ret, !Types::MutationResultType
      return_field :comment, Types::CommentType

      resolve ->(_obj, inputs, ctx) do
        result = Comment::Operation::Update.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          comment = result['model']
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

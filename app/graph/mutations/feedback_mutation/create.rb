module Mutations
  module FeedbackMutation
    Create = GraphQL::Relay::Mutation.define do
      name 'CreateFeedback'

      input_field :name, !types.String
      input_field :email, !types.String
      input_field :title, !types.String
      input_field :content, !types.String

      return_field :ret, !Types::MutationResultType

      resolve ->(_obj, inputs, ctx) do
        result = Feedback::Operation::Create.(
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

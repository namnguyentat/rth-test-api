module Mutations
  module NotificationMutation
    ClearUnseen = GraphQL::Relay::Mutation.define do
      name 'ClearUnseenNotification'

      return_field :ret, !Types::MutationResultType
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = Notification::Operation::ClearUnseen.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        {
          ret: MutationResult.new(result),
          current_user: ctx[:current_user]
        }
      end
    end
  end
end

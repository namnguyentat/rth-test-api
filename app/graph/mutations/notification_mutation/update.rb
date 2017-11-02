module Mutations
  module NotificationMutation
    Update = GraphQL::Relay::Mutation.define do
      name 'UpdateNotification'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :notification, Types::NotificationType

      resolve ->(_obj, inputs, ctx) do
        result = Notification::Operation::Update.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          notification = result['model']
        else
          notification = nil
        end

        {
          ret: MutationResult.new(result),
          notification: notification
        }
      end
    end
  end
end

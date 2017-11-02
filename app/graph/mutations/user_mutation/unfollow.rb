module Mutations
  module UserMutation
    Unfollow = GraphQL::Relay::Mutation.define do
      name 'UnfollowUser'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :user, Types::UserType
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = User::Operation::Unfollow.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          user = result['model'].reload_attribute(:follower_count)
          current_user = ctx[:current_user].reload
        else
          user = nil
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          user: user,
          current_user: current_user
        }
      end
    end
  end
end

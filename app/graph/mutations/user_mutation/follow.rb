module Mutations
  module UserMutation
    Follow = GraphQL::Relay::Mutation.define do
      name 'FollowUser'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :user, Types::UserType
      return_field :user_edge, Types::UserType.edge_type
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = User::Operation::Follow.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          user_connection = GraphQL::Relay::RelationConnection.new(User.all, {})
          user_edge = GraphQL::Relay::Edge.new(result['model'], user_connection)
          user = result['model'].reload_attribute(:follower_count)
          current_user = ctx[:current_user].reload
        else
          user_edge = nil
          user = nil
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          user: user,
          user_edge: user_edge,
          current_user: current_user
        }
      end
    end
  end
end

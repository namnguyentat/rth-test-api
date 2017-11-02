module Mutations
  module SessionMutation
    Create = GraphQL::Relay::Mutation.define do
      name 'CreateSession'

      input_field :oauth_access_token, !types.ID
      input_field :oauth_type, !types.String

      return_field :ret, !Types::MutationResultType
      return_field :session, Types::SessionType
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        oauth_type = inputs.to_h['oauth_type']

        if oauth_type == 'facebook'
          result = Session::Operation::CreateWithFacebook.(inputs.to_h, error_notifier: ctx[:error_notifier])
        elsif oauth_type == 'google'
          result = Session::Operation::CreateWithGoogle.(inputs.to_h, error_notifier: ctx[:error_notifier])
        else
          return {}
        end

        if result.success?
          session = result['model']
          current_user = result['model'].user
        else
          session = nil
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          session: session,
          current_user: current_user
        }
      end
    end
  end
end

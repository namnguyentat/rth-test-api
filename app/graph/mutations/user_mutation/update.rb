module Mutations
  module UserMutation
    Update = GraphQL::Relay::Mutation.define do
      name 'UpdateUser'

      input_field :name, !types.String
      input_field :about, !types.String
      input_field :company, types.String
      input_field :job, types.String

      return_field :ret, !Types::MutationResultType
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = User::Operation::Update.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          current_user = result['model']
        else
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          current_user: current_user
        }
      end
    end
  end
end

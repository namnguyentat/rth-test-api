module Fields
  module EntryPoint
    UserField = GraphQL::Field.define do
      name 'user'
      description 'a user'

      type Types::UserType

      argument :id, !Types::Input::GlobalIdInput

      resolve ->(_obj, args, ctx) do
        result = User::Operation::Show.(args, error_notifier: ctx[:error_notifier])
        result.success? ? result['model'] : nil
      end
    end
  end
end

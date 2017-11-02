module Fields
  module EntryPoint
    CurrentUserField = GraphQL::Field.define do
      name 'current_user'
      description 'current user'

      type Types::UserType

      resolve ->(_obj, _args, ctx) do
        ctx[:current_user]
      end
    end
  end
end

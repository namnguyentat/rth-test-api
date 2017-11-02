module Fields
  UserField = GraphQL::Field.define do
    name 'user'
    description 'A user'

    type Types::UserType

    resolve ->(obj, _args, ctx) do
      RecordLoader.for(User).load(obj.user_id)
    end
  end
end

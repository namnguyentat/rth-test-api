module Fields
  ActorField = GraphQL::Field.define do
    name 'actor'
    description 'A user'

    type Types::UserType

    resolve ->(obj, _args, _ctx) do
      RecordLoader.for(User).load(obj.actor_id)
    end
  end
end

module Fields
  FollowedField = GraphQL::Field.define do
    name 'followed'
    description 'user followed or not'

    type !types.Boolean

    resolve ->(obj, _args, ctx) do
      if ctx[:current_user].present?
        ActionCheckLoader.for(:follow, ctx[:current_user].id, obj.class.name).load(obj.id)
      else
        false
      end
    end
  end
end

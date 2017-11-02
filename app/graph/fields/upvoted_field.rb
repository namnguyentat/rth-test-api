module Fields
  UpvotedField = GraphQL::Field.define do
    name 'upvoted'
    description 'user upvoted or not'

    type !types.Boolean

    resolve ->(obj, _args, ctx) do
      if ctx[:current_user].present?
        ActionCheckLoader.for(:upvote, ctx[:current_user].id, obj.class.name).load(obj.id)
      else
        false
      end
    end
  end
end

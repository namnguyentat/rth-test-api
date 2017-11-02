module Fields
  BookmarkedField = GraphQL::Field.define do
    name 'bookmarked'
    description 'user bookmarked or not'

    type !types.Boolean

    resolve ->(obj, _args, ctx) do
      if ctx[:current_user].present?
        ActionCheckLoader.for(:bookmark, ctx[:current_user].id, obj.class.name).load(obj.id)
      else
        false
      end
    end
  end
end

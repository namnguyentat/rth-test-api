module Fields
  PostsField = GraphQL::Field.define do
    name 'posts'
    description 'post connection'

    type Types::PostType.connection_type

    argument :order_by, types.String, default_value: 'id'
    argument :order, types.String, default_value: 'desc'

    resolve ->(obj, args, _ctx) do
      OneToManyLoader.for(Post, "#{obj.class.name.downcase}_id", args[:order_by], args[:order]).load(obj.id)
    end
  end
end

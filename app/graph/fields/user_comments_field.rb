module Fields
  UserCommentsField = GraphQL::Field.define do
    name 'comments'
    description 'user comments'

    type Types::CommentType.connection_type

    argument :order_by, types.String, default_value: 'id'
    argument :order, types.String, default_value: 'desc'

    resolve ->(obj, args, _ctx) do
      if obj.is_a?(User)
        OneToManyLoader.for(Comment, 'user_id', args[:order_by], args[:order]).load(obj.id)
      else
        raise RuntimeError, 'Loader is not implemented. Fields::CommentsField'
      end
    end
  end
end

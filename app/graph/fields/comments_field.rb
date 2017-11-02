module Fields
  CommentsField = GraphQL::Field.define do
    name 'comments'
    description 'comments'

    type Types::CommentType.connection_type

    argument :order_by, types.String, default_value: 'id'
    argument :order, types.String, default_value: 'desc'

    resolve ->(obj, args, _ctx) do
      OneToManyLoader.for(
        Comment.with_commentable_type(obj.class.name),
        'commentable_id',
        args[:order_by],
        args[:order]
      ).load(obj.id)
    end
  end
end

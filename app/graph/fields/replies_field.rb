module Fields
  RepliesField = GraphQL::Field.define do
    name 'replies'
    description 'replies'

    type Types::ReplyType.connection_type

    argument :order_by, types.String, default_value: 'id'
    argument :order, types.String, default_value: 'desc'

    resolve ->(obj, args, _ctx) do
      if obj.is_a?(Comment)
        OneToManyLoader.for(Reply, 'comment_id', args[:order_by], args[:order]).load(obj.id)
      else
        raise RuntimeError, 'Loader is not implemented. Fields::RepliesField'
      end
    end
  end
end

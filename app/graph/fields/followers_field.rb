module Fields
  FollowersField = GraphQL::Field.define do
    name 'followers'
    description 'followers'

    type Types::UserType.connection_type

    argument :order_by, types.String, default_value: 'id'
    argument :order, types.String, default_value: 'desc'

    resolve ->(obj, args, _ctx) do
      if obj.is_a?(User)
        ManyToManyLoader.for(
          User,
          Follow.with_followable_type('User'),
          'user_id',
          'followable_id',
          args[:order_by],
          args[:order]
        ).load(obj.id)
      else
        raise RuntimeError, 'Loader is not implemented. Fields::FollowersField'
      end
    end
  end
end

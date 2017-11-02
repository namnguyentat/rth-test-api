module Fields
  FollowingUsersField = GraphQL::Field.define do
    name 'following_users'
    description 'following_users'

    type Types::UserType.connection_type

    argument :order_by, types.String, default_value: 'id'
    argument :order, types.String, default_value: 'desc'

    resolve ->(obj, args, _ctx) do
      if obj.is_a?(User)
        ManyToManyLoader.for(
          User,
          Follow.with_followable_type('User'),
          'followable_id',
          'user_id',
          args[:order_by],
          args[:order]
        ).load(obj.id)
      else
        raise RuntimeError, 'Loader is not implemented. Fields::FollowingUsersField'
      end
    end
  end
end

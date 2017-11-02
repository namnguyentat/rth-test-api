module Fields
  NotificationsField = GraphQL::Field.define do
    name 'notifications'
    description 'notifications'

    type Types::NotificationType.connection_type

    argument :order_by, types.String, default_value: 'id'
    argument :order, types.String, default_value: 'desc'

    resolve ->(obj, args, _ctx) do
      if obj.is_a?(User)
        OneToManyLoader.for(Notification, 'user_id', args[:order_by], args[:order]).load(obj.id)
      else
        raise RuntimeError, 'Loader is not implemented. Fields::NotificationsField'
      end
    end
  end
end

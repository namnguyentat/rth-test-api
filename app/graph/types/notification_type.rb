module Types
  NotificationType = Notification.to_graphql_type(
    fields: [
      :created_at,
      :data
    ],
    relay: true
  ) do |obj|
    obj.field :actor, Fields::ActorField
    obj.field :resource, Types::NotificationResourceType
    obj.field :action, !obj.types.String
    obj.field :status, !obj.types.String
    obj.field :kind, obj.types.String
  end
end

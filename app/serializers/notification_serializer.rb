class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :status, :action, :created_at, :actor, :resource_id, :resource_type

  def actor
    actor = object.actor
    return if actor.nil?
    {
      id: actor.id,
      name: actor.name,
      avatar: actor.avatar
    }
  end
end

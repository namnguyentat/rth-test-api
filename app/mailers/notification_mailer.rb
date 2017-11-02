class NotificationMailer < ApplicationMailer
  def notification_email(notification)
    from_user = notification.actor
    to_user = notification.user
    resource = notification.resource
    action = notification.action
    kind = notification.kind

    return if [to_user, from_user, resource].any?(&:blank?)

    title = get_notification_subject(from_user, action, kind)

    @resource = {
      user_avatar: from_user.avatar,
      user_name: from_user.name,
      target_url: get_target_url(resource),
      title: title
    }
    mail(to: to_user.email, subject: title) do |format|
      format.mjml
    end
  end

  def get_target_url(resource)
    case resource.class.name
    when 'Post'
      "#{ENV['WEB_URL']}posts/#{resource.graphql_id}"
    when 'Comment'
      case resource.commentable.class.name
      when 'Post'
        "#{ENV['WEB_URL']}posts/#{resource.commentable.graphql_id}"
      end
    else
      ENV['WEB_URL']
    end
  end

  def get_notification_subject(from_user, action, kind = nil)
    if from_user.present?
      from_name = from_user.name
    elsif kind == 'admin'
      from_name = I18n.t('notification.admin')
    elsif kind == 'system'
      from_name = I18n.t('notification.system')
    end
    "#{from_name} #{I18n.t("notification.#{action}")}"
  end
end

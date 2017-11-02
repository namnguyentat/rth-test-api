module UserHelper
  def increase_user_non_anonymous_count(user:, model:)
    User.increment_counter("non_anonymous_#{model.name.downcase}_count", user.id)
  end

  def decrement_user_non_anonymous_count(user:, model:)
    User.decrement_counter("non_anonymous_#{model.name.downcase}_count", user.id)
  end
end

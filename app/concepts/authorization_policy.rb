class AuthorizationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    return true if user.present?
    unauthorized!
  end

  def show?
    true
  end

  def index?
    true
  end

  def update?
    return true if owned?(record, user)
    unauthorized!
  end

  def destroy?
    return true if owned?(record, user)
    unauthorized!
  end

  protected

  def owned?(record, user)
    user.present? && record.user == user
  end

  def unauthorized!
    raise Pundit::NotAuthorizedError
  end
end

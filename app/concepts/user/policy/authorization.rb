module User::Policy
  class Authorization < AuthorizationPolicy
    protected
    
    def owned?(record, user)
      user.present? && record == user
    end
  end
end

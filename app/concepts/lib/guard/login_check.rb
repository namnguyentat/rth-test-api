module Guard
  class LoginCheck
    include Uber::Callable

    def call(options, **)
      raise Pundit::NotAuthorizedError if options[:current_user].nil?
      true
    end
  end
end

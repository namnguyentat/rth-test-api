module OperationErrorHandler
  def handle_exception(exception, error_notifier)
    error_notifier ||= lambda { |e| Rails.logger.error(e) }
    error_notifier.call(exception)

    case exception
    when ActiveRecord::RecordNotFound
      handle_record_not_found(exception)
    when ActiveRecord::RecordInvalid, ActionController::BadRequest
      handle_record_invalid(exception)
    when Koala::Facebook::AuthenticationError
      handle_authentication_error(exception)
    when Pundit::NotAuthorizedError
      handle_authorization_error(exception)
    else
      handle_standard_error(exception)
    end
  end

  def handle_record_not_found(exception)
    {
      code: Settings.error.not_exist,
      message: exception.message
    }
  end

  def handle_record_invalid(exception)
    {
      code: Settings.error.invalid,
      message: exception.message
    }
  end

  def handle_authentication_error(exception)
    {
      code: Settings.error.unauthenticated,
      message: "Authentication failed"
    }
  end

  def handle_authorization_error(exception)
    {
      code: Settings.error.unauthorized,
      message: "Forbidden"
    }
  end

  def handle_standard_error(exception)
    {
      code: Settings.error.unprocessable,
      message: (Rails.env.development? || Rails.env.test?) ? (exception.message + exception.backtrace.first(10).join('\n')) : nil
    }
  end
end

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :notify_error_and_return

    def notify_error_and_return(exception)
      display_error_in_development(exception)
      notify_airbrake(exception)
      render json: {}, status: :internal_server_error
    end

    def display_error_in_development(exception)
      return if !Rails.env.development?
      Rails.logger.error("\n================================= ERROR START ==================================")
      Rails.logger.error(exception)
      exception.backtrace.each { |trace| Rails.logger.error(trace) }
      Rails.logger.error("================================== ERROR END ===================================\n")
    end
  end
end

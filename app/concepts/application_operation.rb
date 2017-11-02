class ApplicationOperation < Trailblazer::Operation
  extend Contract::DSL
  include OperationErrorHandler

  def handle_exception!(exception, options)
    options['my.error'] = handle_exception(exception, options[:error_notifier])
  end

  def error!(options, **)
    options['my.error'] ||= {code: Settings.error.unprocessable}
  end
end

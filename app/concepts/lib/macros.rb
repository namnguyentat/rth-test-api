module Macros
  def self.FindModel(model:, key:)
    step = ->(input, options) do
      options['model'] = model.find_by!(id: options['params'][key])
    end

    [step, name: "find_model.#{model.name.underscore}_by_#{key}"]
  end

  def self.DestroyModel
    step = ->(input, options) do
      options['model'].destroy
      options['model'].destroyed?
    end

    [step, name: "destroy_model"]
  end

  def self.AssignValidationError
    step = ->(input, options) do
      if options['result.contract.default'] && options['result.contract.default'].errors.full_messages.present?
        options['my.error'] = {
          code: Settings.error.invalid,
          message: options['result.contract.default'].errors.full_messages.join('. ')
        }
      end
    end

    [step, name: "return_validation_error"]
  end

  def self.Authorize(policy, action)
    step = ->(input, options) do
      policy.new(options[:current_user], options['model']).send(action)
    end

    [step, name: "authorize"]
  end
end

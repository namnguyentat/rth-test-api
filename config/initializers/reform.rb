Rails.application.config.reform.validations = :dry

Dry::Validation::Schema.configure do |config|
  # config.messages = :i18n
  config.messages_file = Rails.root.join('config', 'locales', 'errors', "#{I18n.locale}.yml")
  config.predicates = CustomPredicates
end

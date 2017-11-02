RSpec::Matchers.define :match_schema do |expected|
  match do |actual|
    schema =
      MultiJson.load(
        File.read(
          Rails.root.join("spec", "support", "schemas", "#{expected}.json")
        )
      )
    @json_error = JSON::Validator.fully_validate(schema, actual)
    @json_error.empty?
  end

  failure_message do
    @json_error.join(', ')
  end

  description do
    "match schema of `#{expected}`"
  end
end

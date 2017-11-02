module Types
  module Input
    GlobalIdInput = GraphQL::ScalarType.define do
      name "GlobalIdInput"
      description "Global id input type"

      coerce_input ->(value, _ctx) { SchemaHelper.decode_id(value) }
      coerce_result ->(value, _ctx) { value }
    end
  end
end

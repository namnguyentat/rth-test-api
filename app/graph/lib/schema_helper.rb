module SchemaHelper
  SEPARATOR = '---'

  class << self
    def type_name(object)
      object.class.name
    end

    def encode_object(object, type)
      GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id, separator: SEPARATOR)
    end

    def decode_object(id)
      type_name, object_id = GraphQL::Schema::UniqueWithinType.decode(id, separator: SEPARATOR)
      Object.const_get(type_name).find(object_id)
    end

    def decode_id(id)
      _, object_id = GraphQL::Schema::UniqueWithinType.decode(id, separator: SEPARATOR)
      object_id.to_i
    end

    def execute_introspection_query
      AppSchema.execute GraphQL::Introspection::INTROSPECTION_QUERY
    end
  end
end

AppSchema = GraphQL::Schema.define do
  query Types::QueryType
  mutation Types::MutationType

  max_depth 11
  # max_complexity 120

  lazy_resolve(Promise, :sync)
  instrument(:query, GraphQL::Batch::Setup)

  # rescue_from ActiveRecord::RecordNotFound, &:message
  # rescue_from StandardError, &:message

  object_from_id ->(id, _ctx) { SchemaHelper::decode_object(id) }
  id_from_object ->(obj, type, _ctx) { SchemaHelper::encode_object(obj, type) }

  resolve_type ->(object, _ctx) { AppSchema.types[SchemaHelper::type_name(object)] }

  cursor_encoder(URLSafeBase64Encoder)
  
  # # Handle a failed runtime type coercion
  # type_error lambda(type_error, query_ctx) do
  # end
end

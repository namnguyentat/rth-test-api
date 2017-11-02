# class SearchkickRelation
#   def initialize(klass, query:, fields:)
#     @klass = klass
#     @query = query
#     @fields = fields
#     @offset = nil
#   end

#   def pagination_type
#     PaginationType::OFFSET
#   end

#   def model
#     @klass
#   end

#   def limit(limit)
#     @limit = limit
#     self
#   end

#   def offset(offset)
#     @offset = offset
#     self
#   end

#   def results
#     @results ||= @klass.search(@query, fields: @fields, limit: @limit, offset: @offset, match: :word_start).to_a
#   end

#   def to_a
#     results
#   end

#   def map(&block)
#     results.map(&block)
#   end

#   def limit_value
#     @limit
#   end

#   def offset_value
#     @offset
#   end

#   def count
#     results.count
#   end
# end

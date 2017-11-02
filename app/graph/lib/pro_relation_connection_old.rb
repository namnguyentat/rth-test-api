# class ProRelationConnection < GraphQL::Relay::BaseConnection
#   def cursor_from_node(item)
#     if pagination_type == ::PaginationType::OFFSET
#       item_index = paged_nodes_array.index(item)
#       if item_index.nil?
#         raise("Can't generate cursor, item not found in connection: #{item}")
#       else
#         offset = starting_offset + item_index + 1
#         encode(offset.to_s)
#       end
#     else
#       encode(item.id.to_s)
#     end
#   end
#
#   def has_next_page
#     !!(first && paged_nodes && @has_next_page)
#   end
#
#   def has_previous_page
#     if pagination_type == ::PaginationType::OFFSET
#       !!(last && starting_offset > 0)
#     elsif pagination_type == ::PaginationType::CURSOR_ASC
#       !!(last && last_previous_id > 0)
#     elsif pagination_type == ::PaginationType::CURSOR_DESC
#       !!(last && last_previous_id < Settings.system.mysql_max_int)
#     end
#   end
#
#   private
#
#   # If a relation contains a `.group` clause, a `.count` will return a Hash.
#   def count(nodes)
#     count_or_hash = nodes.count
#     count_or_hash.is_a?(Integer) ? count_or_hash : count_or_hash.length
#   end
#
#   # apply first / last limit results
#   def paged_nodes
#     @paged_nodes ||= begin
#       if limit
#         limit_more = limit + 1
#         more_nodes = sliced_nodes.limit(limit_more).to_a
#         if more_nodes.size > limit
#           @has_next_page = true
#           more_nodes[0..-2]
#         else
#           @has_next_page = false
#           more_nodes
#         end
#       else
#         @has_next_page = false
#         sliced_nodes
#       end
#     end
#   end
#
#   # Apply cursors to edges
#   def sliced_nodes
#     if pagination_type == ::PaginationType::OFFSET
#       @sliced_nodes ||= nodes.offset(starting_offset)
#     elsif pagination_type == ::PaginationType::CURSOR_ASC
#       @sliced_nodes ||= nodes.where("#{nodes.model.table_name}.id > #{last_previous_id}")
#     elsif pagination_type == ::PaginationType::CURSOR_DESC
#       @sliced_nodes ||= nodes.where("#{nodes.model.table_name}.id < #{last_previous_id}")
#     else
#       raise RuntimeError, 'invalid pagination type'
#     end
#   end
#
#   def offset_from_cursor(cursor)
#     decode(cursor).to_i
#   end
#
#   def starting_offset
#     @starting_offset ||= begin
#       if before
#         [previous_offset, 0].max
#       elsif last
#         [count(nodes) - last, 0].max
#       else
#         previous_offset
#       end
#     end
#   end
#
#   def last_previous_id
#     @last_previous_id ||= if after
#       decode(after).to_i
#     elsif pagination_type == ::PaginationType::OFFSET
#       0
#     elsif pagination_type == ::PaginationType::CURSOR_ASC
#       0
#     elsif pagination_type == ::PaginationType::CURSOR_DESC
#       Settings.system.mysql_max_int
#     else
#       raise RuntimeError, 'invalid pagination type'
#     end
#   end
#
#   def pagination_type
#     @pagination_type ||= if nodes.respond_to?('pagination_type')
#       nodes.pagination_type
#     elsif nodes.order_values.empty?
#       ::PaginationType::OFFSET
#     else
#       order_sql = nodes.order_values[0].to_sql
#       if order_sql == "`#{nodes.model.table_name}`.`id` ASC"
#         ::PaginationType::CURSOR_ASC
#       elsif order_sql == "`#{nodes.model.table_name}`.`id` DESC"
#         ::PaginationType::CURSOR_DESC
#       else
#         ::PaginationType::OFFSET
#       end
#     end
#   end
#
#   # Offset from the previous selection, if there was one
#   # Otherwise, zero
#   def previous_offset
#     @previous_offset ||= if after
#       offset_from_cursor(after)
#     elsif before
#       prev_page_size = [max_page_size, last].compact.min || 0
#       offset_from_cursor(before) - prev_page_size - 1
#     else
#       0
#     end
#   end
#
#   # Limit to apply to this query:
#   # - find a value from the query
#   # - don't exceed max_page_size
#   # - otherwise, don't limit
#   def limit
#     if pagination_type == ::PaginationType::OFFSET
#       @limit ||= begin
#         limit_from_arguments = if first
#           first
#         else
#           if previous_offset < 0
#             previous_offset + (last ? last : 0)
#           else
#             last
#           end
#         end
#         [limit_from_arguments, max_page_size].compact.min
#       end
#     else
#       @limit ||= begin
#         limit_from_arguments = if first
#           first
#         else
#           raise RuntimeError, 'parameter [first] is required'
#         end
#         [limit_from_arguments, max_page_size].compact.min
#       end
#     end
#   end
#
#   def paged_nodes_array
#     @paged_nodes_array ||= paged_nodes.to_a
#   end
# end

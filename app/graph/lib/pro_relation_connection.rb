class ProRelationConnection < GraphQL::Relay::BaseConnection
  def cursor_from_node(item)
    case pagination_type
    when ::PaginationType::OFFSET
      item_index = paged_nodes_array.index(item)
      if item_index.nil?
        raise("Can't generate cursor, item not found in connection: #{item}")
      else
        offset = item_index + 1 + ((relation_offset(paged_nodes) || 0) - (relation_offset(sliced_nodes) || 0))

        if after
          offset += offset_from_cursor(after)
        elsif before
          offset += offset_from_cursor(before) - 1 - sliced_nodes_count
        end

        encode(offset.to_s)
      end
    when ::PaginationType::CURSOR_ASC, ::PaginationType::CURSOR_DESC
      encode(item.id.to_s)
    else
      raise RuntimeError, 'invalid pagination type'
    end
  end

  def has_next_page
    !!(first && sliced_nodes_count > first)
  end

  def has_previous_page
    case pagination_type
    when ::PaginationType::OFFSET
      !!(last && sliced_nodes_count > last)
    when ::PaginationType::CURSOR_ASC
      !!(last && last_previous_id > 0)
    when ::PaginationType::CURSOR_DESC
      !!(last && last_previous_id < Settings.system.mysql_max_int)
    else
      raise RuntimeError, 'invalid pagination type'
    end
  end

  def first
    return @first if defined? @first

    @first = get_limited_arg(:first)
    @first = max_page_size if @first && max_page_size && @first > max_page_size
    @first
  end

  def last
    return @last if defined? @last

    @last = get_limited_arg(:last)
    @last = max_page_size if @last && max_page_size && @last > max_page_size
    @last
  end

  private

  # apply first / last limit results
  def paged_nodes
    return @paged_nodes if defined? @paged_nodes

    items = sliced_nodes

    if first
      if relation_limit(items).nil? || relation_limit(items) > first
        items = items.limit(first)
      end
    end

    if last
      if relation_limit(items)
        if last <= relation_limit(items)
          offset = (relation_offset(items) || 0) + (relation_limit(items) - last)
          items = items.offset(offset).limit(last)
        end
      else
        offset = (relation_offset(items) || 0) + relation_count(items) - last
        items = items.offset(offset).limit(last)
      end
    end

    if max_page_size && !first && !last
      if relation_limit(items).nil? || relation_limit(items) > max_page_size
        items = items.limit(max_page_size)
      end
    end

    @paged_nodes = items
  end

  def relation_offset(relation)
    if relation.respond_to?(:offset_value)
      relation.offset_value
    else
      relation.opts[:offset]
    end
  end

  def relation_limit(relation)
    if relation.respond_to?(:limit_value)
      relation.limit_value
    else
      relation.opts[:limit]
    end
  end

  # If a relation contains a `.group` clause, a `.count` will return a Hash.
  def relation_count(relation)
    count_or_hash = relation.count
    count_or_hash.is_a?(Integer) ? count_or_hash : count_or_hash.length
  end

  # Apply cursors to edges
  def sliced_nodes
    return @sliced_nodes if defined? @sliced_nodes

    case pagination_type
    when ::PaginationType::OFFSET
      @sliced_nodes = nodes

      if after
        offset = (relation_offset(@sliced_nodes) || 0) + offset_from_cursor(after)
        @sliced_nodes = @sliced_nodes.offset(offset) if after
      end

      if before && after
        if offset_from_cursor(after) < offset_from_cursor(before)
          @sliced_nodes = @sliced_nodes.limit(offset_from_cursor(before) - offset_from_cursor(after) - 1)
        else
          @sliced_nodes = @sliced_nodes.limit(0)
        end
      elsif before
        @sliced_nodes = @sliced_nodes.limit(offset_from_cursor(before) - 1)
      end
    when ::PaginationType::CURSOR_ASC
      @sliced_nodes = nodes.where("#{nodes.model.table_name}.id > #{last_previous_id}")
    when ::PaginationType::CURSOR_DESC
      @sliced_nodes = nodes.where("#{nodes.model.table_name}.id < #{last_previous_id}")
    else
      raise RuntimeError, 'invalid pagination type'
    end

    @sliced_nodes
  end

  def sliced_nodes_count
    return @sliced_nodes_count if defined? @sliced_nodes_count

    # If a relation contains a `.group` clause, a `.count` will return a Hash.
    @sliced_nodes_count = relation_count(sliced_nodes)
  end

  def offset_from_cursor(cursor)
    decode(cursor).to_i
  end

  def paged_nodes_array
    return @paged_nodes_array if defined?(@paged_nodes_array)
    @paged_nodes_array = paged_nodes.to_a
  end

  def last_previous_id
    @last_previous_id ||= if after
      decode(after).to_i
    else
      case pagination_type
      when ::PaginationType::OFFSET, ::PaginationType::CURSOR_ASC
        0
      when ::PaginationType::CURSOR_DESC
        Settings.system.mysql_max_int
      else
        raise RuntimeError, 'invalid pagination type'
      end
    end
  end

  def pagination_type
    @pagination_type ||= if nodes.respond_to?('pagination_type')
      nodes.pagination_type
    elsif nodes.order_values.empty?
      ::PaginationType::OFFSET
    else
      order_sql = nodes.order_values[0].to_sql
      if order_sql == "`#{nodes.model.table_name}`.`id` ASC"
        ::PaginationType::CURSOR_ASC
      elsif order_sql == "`#{nodes.model.table_name}`.`id` DESC"
        ::PaginationType::CURSOR_DESC
      else
        ::PaginationType::OFFSET
      end
    end
  end
end

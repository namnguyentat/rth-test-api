module Fields
  BookmarkedPostsField = GraphQL::Field.define do
    name 'bookmarked_posts'
    description 'bookmarked posts'

    type Types::PostType.connection_type

    argument :order_by, types.String, default_value: 'id'
    argument :order, types.String, default_value: 'desc'

    resolve ->(obj, args, _ctx) do
      if obj.is_a?(User)
        ManyToManyLoader.for(
          Post,
          Bookmark.post,
          'bookmarkable_id',
          'user_id',
          args[:order_by],
          args[:order]
        ).load(obj.id)
      else
        raise RuntimeError, 'Loader is not implemented. Fields::BookmarkedPostsField'
      end
    end
  end
end

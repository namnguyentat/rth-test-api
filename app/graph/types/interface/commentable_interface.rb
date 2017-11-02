module Types
  module Interface
    CommentableInterface = GraphQL::InterfaceType.define do
      name "Commentable"
      description "commentable interface"

      global_id_field(:id)

      field :comment_count, !types.Int
      connection :comments, Fields::CommentsField, max_page_size: Settings.graph.max_page_size
    end
  end
end

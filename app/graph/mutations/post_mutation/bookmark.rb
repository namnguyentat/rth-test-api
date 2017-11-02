module Mutations
  module PostMutation
    Bookmark = GraphQL::Relay::Mutation.define do
      name 'BookmarkPost'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :post_edge, Types::PostType.edge_type
      return_field :post, Types::PostType
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = Post::Operation::Bookmark.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          post_connection = GraphQL::Relay::RelationConnection.new(Post.all, {})
          post_edge = GraphQL::Relay::Edge.new(result['model'], post_connection)
          post = result['model']
          current_user = ctx[:current_user].reload
        else
          post_edge = nil
          post = nil
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          post_edge: post_edge,
          post: post,
          current_user: current_user
        }
      end
    end
  end
end

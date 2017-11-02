module Mutations
  module PostMutation
    CreateComment = GraphQL::Relay::Mutation.define do
      name 'CreatePostComment'

      input_field :commentable_id, !Types::Input::GlobalIdInput
      input_field :content, !types.String

      return_field :ret, !Types::MutationResultType
      return_field :comment_edge, Types::CommentType.edge_type
      return_field :post, Types::PostType
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = Post::Operation::CreateComment.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
          )
          
        if result.success?
          comment_connection = GraphQL::Relay::RelationConnection.new(Comment.all, {})
          comment_edge = GraphQL::Relay::Edge.new(result['model'], comment_connection)
          post = result['model'].commentable
          current_user = ctx[:current_user].reload
        else
          comment_edge = nil
          post = nil
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          comment_edge: comment_edge,
          post: post,
          current_user: current_user
        }
      end
    end
  end
end

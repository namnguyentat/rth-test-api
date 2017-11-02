module Mutations
  module PostMutation
    Create = GraphQL::Relay::Mutation.define do
      name 'CreatePost'

      input_field :title, !types.String
      input_field :content, !types.String

      return_field :ret, !Types::MutationResultType
      return_field :post_edge, Types::PostType.edge_type
      return_field :current_user, Types::UserType

      resolve ->(_obj, inputs, ctx) do
        result = Post::Operation::Create.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          post_connection = GraphQL::Relay::RelationConnection.new(Post.all, {})
          post_edge = GraphQL::Relay::Edge.new(result['model'], post_connection)
          current_user = ctx[:current_user].reload
        else
          post_edge = nil
          current_user = nil
        end

        {
          ret: MutationResult.new(result),
          post_edge: post_edge,
          current_user: current_user
        }
      end
    end
  end
end

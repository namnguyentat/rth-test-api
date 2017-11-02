module Mutations
  module PostMutation
    Upvote = GraphQL::Relay::Mutation.define do
      name 'UpvotePost'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :post, Types::PostType

      resolve ->(_obj, inputs, ctx) do
        result = Post::Operation::Upvote.(
          inputs.to_h,
          current_user: ctx[:current_user],
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          post = result['model'].reload_attribute(:upvote_count)
        else
          post = nil
        end

        {
          ret: MutationResult.new(result),
          post: post
        }
      end
    end
  end
end

module Mutations
  module PostMutation
    View = GraphQL::Relay::Mutation.define do
      name 'ViewPost'

      input_field :id, !Types::Input::GlobalIdInput

      return_field :ret, !Types::MutationResultType
      return_field :post, Types::PostType

      resolve ->(_obj, inputs, ctx) do
        result = Post::Operation::View.(
          inputs.to_h,
          error_notifier: ctx[:error_notifier]
        )

        if result.success?
          post = result['model'].reload_attribute(:view_count)
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

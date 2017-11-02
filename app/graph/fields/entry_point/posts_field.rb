module Fields
  module EntryPoint
    PostsField = GraphQL::Field.define do
      name 'posts'
      description 'posts'

      type Types::PostType.connection_type

      resolve ->(_obj, args, ctx) do
        result = Post::Operation::Index.(
          args, 
          current_user: ctx[:current_user], 
          error_notifier: ctx[:error_notifier]
        )
        result.success? ? result['models'] : nil
      end
    end
  end
end

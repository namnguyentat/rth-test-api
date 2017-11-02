module Fields
  module EntryPoint
    PostField = GraphQL::Field.define do
      name 'post'
      description 'a post'

      type Types::PostType

      argument :id, !Types::Input::GlobalIdInput

      resolve ->(_obj, args, ctx) do
        result = Post::Operation::Show.(args, error_notifier: ctx[:error_notifier])
        result.success? ? result['model'] : nil
      end
    end
  end
end

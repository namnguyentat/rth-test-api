module Fields
  module EntryPoint
    CommentField = GraphQL::Field.define do
      name 'comment'
      description 'entry comment'

      type Types::CommentType

      argument :id, !Types::Input::GlobalIdInput

      resolve ->(obj, args, ctx) do
        result = Comment::Operation::Show.(args, error_notifier: ctx[:error_notifier])
        result.success? ? result['model'] : nil
      end
    end
  end
end

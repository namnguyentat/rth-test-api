module Fields
  CommentField = GraphQL::Field.define do
    name 'comment'
    description 'comment'

    type Types::CommentType

    resolve ->(obj, _args, _ctx) do
      RecordLoader.for(Comment).load(obj.comment_id)
    end
  end
end

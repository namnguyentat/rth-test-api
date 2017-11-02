module Fields
  CommentableField = GraphQL::Field.define do
    name 'commentable'
    description 'commentable'

    type Types::Interface::CommentableInterface

    resolve ->(obj, _args, _ctx) do
      return nil if obj.commentable_id.nil? || obj.commentable_type.nil?
      RecordLoader.for(obj.commentable_type.constantize).load(obj.commentable_id)
    end
  end
end

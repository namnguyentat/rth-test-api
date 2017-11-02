module Types
  MutationType = GraphQL::ObjectType.define do
    name 'Mutation'

    field :CreateSession, field: Mutations::SessionMutation::Create.field
    field :DestroySession, field: Mutations::SessionMutation::Destroy.field

    field :UpdateComment, field: Mutations::CommentMutation::Update.field
    field :DestroyComment, field: Mutations::CommentMutation::Destroy.field
    field :UpvoteComment, field: Mutations::CommentMutation::Upvote.field
    field :UnupvoteComment, field: Mutations::CommentMutation::Unupvote.field

    field :CreateReply, field: Mutations::ReplyMutation::Create.field
    field :UpdateReply, field: Mutations::ReplyMutation::Update.field
    field :DestroyReply, field: Mutations::ReplyMutation::Destroy.field
    field :UpvoteReply, field: Mutations::ReplyMutation::Upvote.field
    field :UnupvoteReply, field: Mutations::ReplyMutation::Unupvote.field

    field :CreatePost, field: Mutations::PostMutation::Create.field
    field :UpvotePost, field: Mutations::PostMutation::Upvote.field
    field :UnupvotePost, field: Mutations::PostMutation::Unupvote.field
    field :BookmarkPost, field: Mutations::PostMutation::Bookmark.field
    field :UnbookmarkPost, field: Mutations::PostMutation::Unbookmark.field
    field :ViewPost, field: Mutations::PostMutation::View.field
    field :CreatePostComment, field: Mutations::PostMutation::CreateComment.field

    field :FollowUser, field: Mutations::UserMutation::Follow.field
    field :UnfollowUser, field: Mutations::UserMutation::Unfollow.field
    field :UpdateUser, field: Mutations::UserMutation::Update.field
    field :ChangeAvatarUser, field: Mutations::UserMutation::ChangeAvatar.field
    field :CompleteOnboardingUser, field: Mutations::UserMutation::CompleteOnboarding.field

    field :MarkNotificationsAsRead, field: Mutations::NotificationMutation::MarkAsRead.field
    field :ClearUnseenNotification, field: Mutations::NotificationMutation::ClearUnseen.field
    field :UpdateNotification, field: Mutations::NotificationMutation::Update.field

    field :CreateFeedback, field: Mutations::FeedbackMutation::Create.field
  end
end

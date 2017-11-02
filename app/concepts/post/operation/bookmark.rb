module Post::Operation
  class Bookmark < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Policy::Guard(Guard::LoginCheck.new)
      step Macros::FindModel(model: Post, key: 'id')
      step :create_bookmark!
      failure :error!
    }

    def create_bookmark!(options, current_user:, **)
      options['model'].bookmarkers << current_user
    end
  end
end

module Post::Operation
  class View < ApplicationOperation
    step Rescue(StandardError, handler: :handle_exception!) {
      step Macros::FindModel(model: Post, key: 'id')
      step :update_post_view_count!
      failure :error!
    }

    def update_post_view_count!(options, **)
      # TODO: Need better strategy to cope with concurrency and Performance issue
      options['model'].increment!(:view_count)
      options['model'].save
    end
  end
end

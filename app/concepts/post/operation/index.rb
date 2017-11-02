module Post::Operation
  class Index < ApplicationOperation
    step :index!

    def index!(options, params:, current_user:, **)
      options['models'] = Post.order(id: :desc)
    end
  end
end

module Post::Operation
  class Search < ApplicationOperation
    step :find_posts!

    def find_posts!(options, params:, **)
      options['models'] = Post.where("title Like ?", "#{params['phrase']}")
    end
  end
end

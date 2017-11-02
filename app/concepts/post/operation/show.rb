module Post::Operation
  class Show < ApplicationOperation
    step :find_post!

    def find_post!(options, params:, **)
      options['model'] = Post.find_by(id: params[:id])
    end
  end
end

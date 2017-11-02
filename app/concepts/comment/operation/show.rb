module Comment::Operation
  class Show < ApplicationOperation
    step :find_comment!

    def find_comment!(options, params:, **)
      options['model'] = Comment.find_by(id: params[:id])
    end
  end
end

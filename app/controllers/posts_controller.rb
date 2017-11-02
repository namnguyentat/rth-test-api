class PostsController < ApplicationController
  def index
    @posts = Post.order(created_at: :DESC)
    render json: @posts, status: :ok
  end

  def show
    @post = Post.find_by(id: params[:id])
    render json: @post, status: :ok
  end
end

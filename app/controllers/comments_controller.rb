class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[ show ]
  # GET post/1/comments
  # GET post/1/comments.json
  def index
    puts("post_comments_url(@post): #{post_comments_url(@post)}")
    puts("Post: #{@post.inspect}")
    @comments = @post.comments
  end

  # POST post/1/comments
  # POST post/1/comments.json
  def create
    @comment = @post.comments.build(comment_params)

    if @comment.save
      render :show, status: :created
    else
      render json: @comment.errors, status: :unprocessable_content
    end
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.expect(comment: [ :name, :content ])
    end
end

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show update destroy ]

  # GET post/1/comments
  # GET post/1/comments.json
  def index
    @comments = Comment.all
  end

  # GET post/1/comments/1
  # GET post/1/comments/1.json
  def show
  end

  # POST post/1/comments
  # POST post/1/comments.json
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render :show, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT post/1/comments/1
  # PATCH/PUT post/1/comments/1.json
  def update
    if @comment.update(comment_params)
      render :show, status: :ok, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_content
    end
  end

  # DELETE post/1/comments/1
  # DELETE post/1/comments/1.json
  def destroy
    @comment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.expect(comment: [ :name, :content, :post_id_id ])
    end
end

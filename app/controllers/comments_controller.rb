class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:update, :destroy]

  def create
    @comment = Comment.new(comment_params)
    @post = Post.find(@comment.post_id)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to user_url(@post.user_id), notice: 'Comment was successfully created.' }
        format.js {render :redraw, notice: 'Comment was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to user_url(@post.user_id), notice: 'Comment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to user_url(@post.user_id), notice: 'Comment was successfully destroyed.' }
      format.js {render :redraw, notice: 'Comment was successfully destroyed.'}
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end
    
    def set_post
      @post = Post.find(@comment.post_id)
    end
    
    def comment_params
      params.require(:comment).permit(:post_id, :user_id, :content)
    end
end

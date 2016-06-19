class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user_post, only: [:edit, :update, :destroy]
  
  def index
    @posts = Post.order(created_at: :desc).page(params[:page])
    @comments = []
    @comment = []
    @posts.each do |post|
      @comments[post.id] = post.comments
      @comment[post.id] = post.comments.build
    end
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    correct_user_post
    respond_to do |format|
      if @post.save
        format.html { redirect_to user_url(@post.user_id), notice: '記事を投稿しました。' }
      else
        format.html { render :new }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to user_url(@post.user_id), notice: '記事の内容を更新しました。' }
      else
        format.html { render :edit }
      end
    end
  end
  
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to user_url(@post.user_id), notice: '記事を削除しました。' }
    end
  end
  
  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :user_id )
    end
    
    def correct_user_post
      redirect_to(root_url) unless @post.user_id == current_user.id
    end
end
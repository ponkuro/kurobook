class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :about, :friend, :following, :followed]
  
  def index
    @users = User.order(updated_at: :desc).page(params[:page])
  end

  def show
    @posts = @user.posts.order(created_at: :desc).page(params[:page])
    @comments = []
    @comment = []
    @posts.each do |post|
      @comments[post.id] = post.comments
      @comment[post.id] = post.comments.build
    end
  end
  
  def about
  end
  
  def friend
    @users = @user.friend_users.page(params[:page])
  end
  
  def friendship
    @user = User.find(current_user.id)
    @users = User.order(updated_at: :desc).page(params[:page])
  end
  
  def following
    @users = @user.following_users.page(params[:page])
    render :index
  end

  def followed
    @users = @user.followers.page(params[:page])
    render :index
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end

class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.order(updated_at: :desc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @comments = []
    @comment = []
    @posts.each do |post|
      @comments[post.id] = post.comments
      @comment[post.id] = post.comments.build
    end
  end
end

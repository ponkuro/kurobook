class TopController < ApplicationController
  
  def index
    if user_signed_in?
      @user = User.find(current_user.id)
      @users = @user.friend_users
      selected_users = @users.push(@user)
      @posts = Post.where(user_id: selected_users).order(created_at: :desc).page(params[:page])
      @comments = []
      @comment = []
      @posts.each do |post|
        @comments[post.id] = post.comments
        @comment[post.id] = post.comments.build
      end
    end
  end
end

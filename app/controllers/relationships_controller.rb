class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @user = User.find(params[:relationship][:receiver_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to :back, notice: 'フレンド申請を送りました。' }
      format.js {render :redraw, notice: 'フレンド申請を送りました。'}
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).receiver
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to :back, notice: 'フレンドを解除しました。' }
      format.js {render :redraw, notice: 'フレンドを解除しました。'}
    end
  end
end
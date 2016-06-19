class ContactController < ApplicationController
  
  def index
    # 入力画面を表示
    if params[:back]
      @contact = Contact.new(contact_params)
      render :action => 'index'
    else
      @contact = Contact.new
      render :action => 'index'
    end
  end

  def confirm
    # 入力値のチェック
    @contact = Contact.new(contact_params)
    if @contact.valid?
      # OK。確認画面を表示
      render :action => 'confirm'
    else
      # NG。入力画面を再表示
      render :action => 'index'
    end
  end

  def thanks
    write_db
  end

  private
    # DBに書き込み
    def write_db
      @contact = Contact.new(contact_params)
      respond_to do |format|
        if @contact.save
          # deliverメソッドを使って、メールを送信する
      	  NoticeMailer.post_thanks_email(@contact).deliver
          format.html { render :action => 'thanks' }
        else
          format.html { render :action => 'index' }
        end
      end
    end
    
    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
end
class Contact < ActiveRecord::Base
    
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence => {:message => 'お名前が未入力です'}
  validates :email, :presence => {:message => 'メールアドレスが未入力です'}
  validates :email, format: { with: VALID_EMAIL_REGEX, :message => 'メールアドレスが不正です' }
  validates :message, :presence => {:message => 'お問い合わせ内容が未入力です'}
end
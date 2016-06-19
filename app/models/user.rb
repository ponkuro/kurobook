class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  mount_uploader :image, ImageUploader
  paginates_per 20
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  #フォローしている関係を定義
  has_many :relationships, class_name: "Relationship", foreign_key: "sender_id", dependent: :destroy
  has_many :following_users, through: :relationships, source: :receiver
  #フォローされている関係を定義
  has_many :received_relationships, class_name: "Relationship", foreign_key: "receiver_id", dependent: :destroy
  has_many :followers, through: :received_relationships, source: :sender
  
  ######################################
  ##  ユーザー認証に関連したメソッド  ##
  ######################################
  
  # UUID(Universally Unique Identifier)を生成
  def self.create_unique_string 
    SecureRandom.uuid 
  end

  # ユニークなEmailを自動生成 <-- Twitter認証時に使用
  def self.create_unique_email 
    User.create_unique_string + "@example.com" 
  end

  # facebook認証時の処理
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil) 
    user = User.where(provider: auth.provider, uid: auth.uid).first
    
    # データベースに該当ユーザーが存在しない場合 <-- 新規登録時
    unless user 
      user = User.new(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0,20]
      )
      # メールアドレスを取得できない時は自動生成する
      unless user.email?
        user.email = User.create_unique_email
      end
      
      user.remote_image_url = "https://graph.facebook.com/#{user.uid}/picture?width=120&height=120"
      user.skip_confirmation!
      user.save(:validate => false)
    end
    
    # 処理が終わる前に戻り値として明示的にセット
    user
    
  end

  # twitter認証時の処理
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil) 
    user = User.where(provider: auth.provider, uid: auth.uid).first
    
    # データベースに該当ユーザーが存在しない場合 <-- 新規登録時
    unless user 
      user = User.new(
        name: auth.info.nickname,
        provider: auth.provider,
        uid: auth.uid,
        email: User.create_unique_email,
        password: Devise.friendly_token[0,20]
      )
      
      user.remote_image_url = "http://furyu.nazo.cc/twicon/#{user.name}/original"
      user.skip_confirmation!
      user.save(:validate => false)
    end
    
    # 処理が終わる前に戻り値として明示的にセット
    user
    
  end
  
  ######################################
  ##  フレンド機能に関連したメソッド  ##
  ######################################
  
  # 指定したuserをフォローする
  def follow!(target_user)
    relationships.create!(receiver_id: target_user.id)
  end

  # 指定したuserのフォローを解除する
  def unfollow!(target_user)
    relationships.find_by(receiver_id: target_user.id).destroy
  end
  
  # 指定したuserをフォローしているか確認する
  def following?(target_user)
    relationships.find_by(receiver_id: target_user.id)
  end

  # 指定したuserにフォローされているか確認する
  def followed?(target_user)
    received_relationships.find_by(sender_id: target_user.id)
  end

  # 自身とフレンド関係にあるuser一覧を取得する
  def friend_users
    User.get_friendlist(self)
  end

  def self.get_friendlist(target_user)
    sql1 = "SELECT users.* FROM users INNER JOIN relationships ON users.id = relationships.receiver_id WHERE relationships.sender_id = :user_id"
    sql2 = "SELECT users.* FROM users INNER JOIN relationships ON users.id = relationships.sender_id WHERE relationships.receiver_id = :user_id"
    friend_user_ids = "SELECT X.id FROM (#{sql1}) X INNER JOIN (#{sql2}) Y ON X.id = Y.id"
    where("id IN (#{friend_user_ids})", user_id: target_user.id)
  end
end
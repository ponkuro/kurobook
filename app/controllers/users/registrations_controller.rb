class Users::RegistrationsController < Devise::RegistrationsController

  def build_resource(hash=nil) 
    hash[:uid] = User.create_unique_string 
    super 
  end
  
  # OAuthで認証されたユーザーはパスワード判定を回避したいのでOverride
  def update_resource(resource, params)
    if current_user.provider?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
  
end
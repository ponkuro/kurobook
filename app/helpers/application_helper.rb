module ApplicationHelper
  
  # 改行をbrに変換して表示
  def hbr(text)
    html_escape(text).gsub(/\r\n|\r|\n/, "<br />").html_safe
  end
  
  # プロフィール画像のURLを設定
  def profile_image_url(user)
    unless user.image?
      url = asset_path "default-img.jpg"
    else
      url = user.image.url
    end
    url
  end
  
  # プロフィール画像(small)のURLを設定
  def profile_image_small_url(user)
    unless user.image?
      url = asset_path "default-img-small.jpg"
    else
      url = user.image.small.url
    end
    url
  end

  # プロフィール画像(mini)のURLを設定
  def profile_image_mini_url(user)
    unless user.image?
      url = asset_path "default-img-mini.jpg"
    else
      url = user.image.mini.url
    end
    url
  end
  
end
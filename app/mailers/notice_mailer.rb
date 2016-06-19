class NoticeMailer < ApplicationMailer
  default from: "pon.kurose.test@gmail.com"

  def post_thanks_email(post)
    @contact = post
    mail to: post.email, subject: "【Achieve】お問い合わせを受け付けました。"
  end
end
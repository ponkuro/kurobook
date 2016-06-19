class Post < ActiveRecord::Base
  paginates_per 5
  belongs_to :user
  has_many :comments, dependent: :destroy
end

class Comment < ActiveRecord::Base
  include Voteable

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post

  validates :body, presence: true, length: {minimum: 3}
  validates :user_id, presence: true
  validates :post_id, presence: true

end
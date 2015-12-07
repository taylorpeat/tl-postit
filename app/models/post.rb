class Post < ActiveRecord::Base
  include Voteable
  include Slugable

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
 

  validates :user_id, presence: true
  validates :title, presence: true, length: {minimum: 3}
  validates :description, presence: true, length: {minimum: 3}
  validates :url, presence: true

  slugable_column :title
  
end
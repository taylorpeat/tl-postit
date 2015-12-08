class User < ActiveRecord::Base
  include Slugable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, length: {minimum: 4}, uniqueness: true
  #validates :password, presence: true, length: {minimum: 4}, on: :create, on: :update

  slugable_column :username
  
end
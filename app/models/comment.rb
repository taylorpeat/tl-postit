class Comment < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post
  has_many :votes, as: :voteable

  validates :body, presence: true, length: {minimum: 3}
  validates :user_id, presence: true
  validates :post_id, presence: true

  def vote_total
    self.votes.where(vote: true).size - self.votes.where(vote: false).size
  end
end
class Article < ActiveRecord::Base
  belongs_to :user
  validates :title,presence: true, length: {minimum: 3, maximum:350}
  validates :user_id, presence: true
  validates :description,presence: true, length: {minimum:3, maximum:10000}
  has_many :article_categories
  has_many :categories, through: :article_categories
end


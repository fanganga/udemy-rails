class Article < ActiveRecord::Base
  validates :title,presence: true, length: {minimum: 3, maximum:350}
  validates :description,presence: true, length: {minimum:3}
end


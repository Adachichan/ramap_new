class Comment < ApplicationRecord

  belongs_to :review

  validates :poster, presence: true
  validates :content, presence: true

end

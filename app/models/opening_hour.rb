class OpeningHour < ApplicationRecord

  belongs_to :store

  validates :opening_time, presence: true
  validates :closing_time, presence: true

end

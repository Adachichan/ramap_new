class StoreGenre < ApplicationRecord

  has_many :stores

  validates :name, presence: true, uniqueness: true

end

class Day < ApplicationRecord

  has_many :stores, through: :regular_holidays
  has_many :regular_holidays

end

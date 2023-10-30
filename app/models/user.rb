class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :stores, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def self.guest
    find_or_create_by!(email: 'guest@example.com', name: 'guest', name_kana: 'guest', nickname: 'guest', postal_code: '9999999', address: 'xxxxxx', telephone_number: '9999999999', sex: 0) do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  validates :name, presence: true
  validates :name_kana, presence: true
  validates :nickname, presence: true
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ } # 7桁の半角数字
  validates :sex, presence: true
  validates :address, presence: true
  validates :telephone_number, presence: true, format: { with: /\A\d{10,11}\z/ } # 半角数字ハイフンなしで10桁or11桁

  enum sex: { man: 0, woman: 1 }

end

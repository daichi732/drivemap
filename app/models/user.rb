class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true

  has_many :places, dependent: :destroy

  def own?(place)
    self == place.user
  end
end

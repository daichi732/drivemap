class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true
  validate :avatar_format
  has_secure_password
  has_one_attached :avatar

  has_many :places, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def own?(place)
    self == place.user
  end

  def own?(comment)
    self == comment.user
  end

  def avatar_format
    if avatar.attached?
      errors.add(:avatar, 'にはjpegまたはgifまたはpngファイルを添付してください') unless avatar.content_type.in?(%('image/jpeg image/gif image/png'))
    end
  end
end

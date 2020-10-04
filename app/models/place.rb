class Place < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validate :image_presence_or_format

  validates :genre, presence: true
  validates :address, presence: true
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image
  scope :recent, -> { order(created_at: :desc) }
  geocoded_by :address
  after_validation :geocode
  enum genre: { food: 0, view: 1, amusement: 2 }

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  def image_presence_or_format
    return errors.add(:image, 'ファイルを添付してください') unless image.attached?
    errors.add(:image, 'にはjpegまたはgifまたはpngファイルを添付してください') unless image.content_type.in?(%('image/jpeg image/gif image/png'))
  end
end

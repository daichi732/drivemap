class Place < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20}
  belongs_to :user
  has_many :likes
  has_one_attached :image
  scope :recent, -> { order(created_at: :desc) }
  geocoded_by :address
  after_validation :geocode
  enum genre: { food: 0, view: 1, amusement: 2}

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end

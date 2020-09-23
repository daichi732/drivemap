class Place < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20}
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image
  scope :recent, -> { order(created_at: :desc) }

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end

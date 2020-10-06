class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true
  validate :avatar_format
  has_secure_password
  has_one_attached :avatar

  has_many :places, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :schedules, dependent: :destroy

  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

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

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end

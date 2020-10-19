class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  before_save { self.email = email.downcase }
  validates :email, {presence: true, uniqueness: { case_sensitive: false }}
  validate :avatar_format
  has_secure_password
  has_one_attached :avatar

  has_many :places, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :schedules, dependent: :destroy

  has_many :active_relationships,  class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  def avatar_format
    return true unless avatar.attached?

    errors.add(:avatar, 'にはjpegまたはgifまたはpngファイルを添付してください') unless avatar.content_type.in?(%('image/jpeg image/gif image/png'))
  end
  
  def own?(object)
  # object -> { place, comment, schedule }
    self == object.user
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

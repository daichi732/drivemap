class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 20}
  validates :email, presence: true

  has_many :places, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def own?(comment)
    self == comment.user
  end
end

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :place
  validates :user_id, presence: true
  validates :place_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }
end

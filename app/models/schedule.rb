class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :place
  validates :user_id, presence: true
  validates :place_id, presence: true
  validates :date, presence: true
end

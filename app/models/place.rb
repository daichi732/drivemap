class Place < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20}

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }
end

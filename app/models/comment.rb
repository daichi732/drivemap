class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :place
  validates :content, presence: true
  
end

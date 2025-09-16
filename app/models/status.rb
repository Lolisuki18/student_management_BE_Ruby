class Status < ApplicationRecord
  has_many :students, dependent: :destroy
  
  validates :status_name, presence: true, uniqueness: true
  validates :description, presence: true
end
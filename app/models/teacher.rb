class Teacher < ApplicationRecord
  belongs_to :user
  has_many :courses, dependent: :destroy, class_name: "Course"
  
  validates :full_name, presence: true
  validates :teacher_code, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :department, presence: true
end
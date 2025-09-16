class StudentClass < ApplicationRecord
  belongs_to :student
  belongs_to :course, class_name: "Course", foreign_key: :class_id
  
  validates :student_id, uniqueness: { scope: :class_id }
  validates :enrolled_at, presence: true
end
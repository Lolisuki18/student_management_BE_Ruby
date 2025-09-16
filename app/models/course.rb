class Course < ApplicationRecord
  self.table_name = "classes"
  
  belongs_to :teacher
  has_many :student_classes, dependent: :destroy, foreign_key: :class_id
  has_many :students, through: :student_classes
  
  validates :name_class, presence: true
  validates :class_code, presence: true, uniqueness: true
  validates :student_limit, presence: true, numericality: { greater_than: 0 }
end
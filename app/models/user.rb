class User < ApplicationRecord
  belongs_to :role
  has_one :teacher, dependent: :destroy
  has_one :student, dependent: :destroy
  
  has_secure_password # Sử dụng bcrypt để mã hoá mật khẩu
  
  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
end
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data (optional - uncomment if you want to reset data)
# StudentClass.destroy_all
# Student.destroy_all
# Teacher.destroy_all
# Class.destroy_all
# User.destroy_all
# Role.destroy_all
# Status.destroy_all

puts "Creating sample data..."

# Create Roles
puts "Creating roles..."
admin_role = Role.find_or_create_by!(role_name: "Admin") do |role|
  role.description = "System Administrator"
  role.active = true
end

teacher_role = Role.find_or_create_by!(role_name: "Teacher") do |role|
  role.description = "Teacher Role"
  role.active = true
end

student_role = Role.find_or_create_by!(role_name: "Student") do |role|
  role.description = "Student Role"
  role.active = true
end

# Create Statuses for Students
puts "Creating student statuses..."
active_status = Status.find_or_create_by!(status_name: "Active") do |status|
  status.description = "Student is currently enrolled and active"
end

inactive_status = Status.find_or_create_by!(status_name: "Inactive") do |status|
  status.description = "Student is temporarily inactive"
end

graduated_status = Status.find_or_create_by!(status_name: "Graduated") do |status|
  status.description = "Student has graduated"
end

suspended_status = Status.find_or_create_by!(status_name: "Suspended") do |status|
  status.description = "Student is suspended"
end

# Create Admin User
puts "Creating admin user..."
admin_user = User.find_or_create_by!(user_name: "admin") do |user|
  user.password = "admin123"
  user.email = "admin@university.edu"
  user.phone = "0123456789"
  user.active = true
  user.role = admin_role
end

# Create Teacher Users
puts "Creating teacher users..."
teacher_users = []
5.times do |i|
  teacher_user = User.find_or_create_by!(user_name: "teacher#{i+1}") do |user|
    user.password = "teacher123"
    user.email = "teacher#{i+1}@university.edu"
    user.phone = "098765432#{i}"
    user.active = true
    user.role = teacher_role
  end
  teacher_users << teacher_user
end

# Create Teachers
puts "Creating teachers..."
teachers = []
teacher_names = ["Nguyễn Văn An", "Trần Thị Bình", "Lê Hoàng Cường", "Phạm Thị Dung", "Hoàng Văn Em"]
departments = ["Computer Science", "Mathematics", "Physics", "Chemistry", "English"]

teacher_names.each_with_index do |name, index|
  teacher = Teacher.find_or_create_by!(teacher_code: "T#{(index+1).to_s.rjust(3, '0')}") do |t|
    t.full_name = name
    t.user = teacher_users[index]
    t.birthday = Date.new(1980 + rand(15), rand(12) + 1, rand(28) + 1)
    t.phone = "098765432#{index}"
    t.email = "teacher#{index+1}@university.edu"
    t.description = "Experienced teacher in #{departments[index]}"
    t.department = departments[index]
  end
  teachers << teacher
end

# Create Classes
puts "Creating classes..."
courses = []
class_names = ["Web Development", "Data Structures", "Database Systems", "Machine Learning", "Software Engineering"]
class_codes = ["WEB101", "DS201", "DB301", "ML401", "SE501"]

class_names.each_with_index do |name, index|
  course = Course.find_or_create_by!(class_code: class_codes[index]) do |c|
    c.name_class = name
    c.teacher = teachers[index]
    c.description = "#{name} course for computer science students"
    c.student_limit = 30 + rand(20)
    c.active = true
  end
  courses << course
end

# Create Student Users
puts "Creating student users..."
student_users = []
20.times do |i|
  student_user = User.find_or_create_by!(user_name: "student#{i+1}") do |user|
    user.password = "student123"
    user.email = "student#{i+1}@student.university.edu"
    user.phone = "091234567#{i.to_s.rjust(2, '0')}"
    user.active = true
    user.role = student_role
  end
  student_users << student_user
end

# Create Students
puts "Creating students..."
students = []
first_names = ["Nguyễn", "Trần", "Lê", "Phạm", "Hoàng", "Huỳnh", "Phan", "Vũ", "Võ", "Đặng"]
middle_names = ["Văn", "Thị", "Hoàng", "Minh", "Thanh", "Thu", "Hải", "Quốc", "Đức", "Anh"]
last_names = ["An", "Bình", "Cường", "Dung", "Em", "Phương", "Giang", "Hùng", "Linh", "Khoa"]
majors = ["Computer Science", "Information Technology", "Software Engineering", "Data Science"]
classes_study = ["CS2021", "IT2021", "SE2021", "DS2021", "CS2022"]
academy_years = ["2021-2025", "2022-2026", "2023-2027"]

20.times do |i|
  full_name = "#{first_names.sample} #{middle_names.sample} #{last_names.sample}"
  student = Student.find_or_create_by!(student_code: "S#{(i+1).to_s.rjust(6, '0')}") do |s|
    s.full_name = full_name
    s.major = majors.sample
    s.birthday = Date.new(2000 + rand(5), rand(12) + 1, rand(28) + 1)
    s.class_study = classes_study.sample
    s.academy_year = academy_years.sample
    s.user = student_users[i]
    s.status = [active_status, inactive_status].sample
  end
  students << student
end

# Create Student-Class relationships
puts "Creating student-class enrollments..."
students.each do |student|
  # Each student enrolls in 2-4 random classes
  enrolled_courses = courses.sample(rand(2..4))
  enrolled_courses.each do |course|
    StudentClass.find_or_create_by!(student: student, class_id: course.id) do |sc|
      sc.enrolled_at = Time.current - rand(365).days
      sc.active = true
    end
  end
end

puts "Sample data created successfully!"
puts "Created:"
puts "- #{Role.count} roles"
puts "- #{Status.count} statuses"
puts "- #{User.count} users"
puts "- #{Teacher.count} teachers"
puts "- #{Course.count} courses"
puts "- #{Student.count} students"
puts "- #{StudentClass.count} student-class enrollments"

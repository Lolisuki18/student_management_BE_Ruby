class Student < ApplicationRecord
  belongs_to :user  
  belongs_to :status
  has_many :student_classes, dependent: :destroy
  
  has_many :courses, through: :student_classes, class_name: "Course"
  
  # validation là phải kiểu tra dữ liệu trước khi lưu vào db
  # các validation cơ bản
  #presence: true là bắt buộc phải có
  #uniqueness: true là không được trùng lặp
  validates :full_name, presence: true
  validates :student_code, presence: true, uniqueness: true
  validates :major, presence: true
  validates :class_study, presence: true
  validates :academy_year, presence: true

  # Scopes
   # Scopes là named query giúp tái sử dụng các truy vấn phổ biến
   
 # active: trạng thái đang học scope này dùng để lọc ra những sinh viên có trạng thái của sinh viên
  scope :active, -> { joins(:status).where(statuses: { status_name: 'Active' }) }
  scope :inactive, -> { joins(:status).where(statuses: { status_name: 'Inactive' }) }
  scope :graduated, -> { joins(:status).where(statuses: { status_name: 'Graduated' }) }
  scope :suspended, -> { joins(:status).where(statuses: { status_name: 'Suspended' }) }
  scope :not_suspended, -> { joins(:status).where.not(statuses: { status_name: 'Suspended' }) }
  
  # Scope filter với kiểm tra present?
  # present? là kiểm tra nil hoặc rỗng
  # Nếu có giá trị thì mới where

  scope :by_class, ->(class_id) { where(class_id: class_id) if class_id.present? }
  scope :by_major, ->(major) { where(major: major) if major.present? }
  scope :by_year, ->(year) { where(academy_year: year) if year.present? }
  
  #  Scope search
  # search là tìm kiếm
  # ILIKE là tìm kiếm không phân biệt hoa thường trong postgresql nhưng mình dùng mysql thì dùng LIKE

  scope :search, ->(query) {
    where("full_name LIKE ? OR student_code LIKE ?", "%#{query}%", "%#{query}%") if query.present?
  }
  
  # scope includes để tránh n+1 query
  # N+1 query là gì?
  # N+1 query là khi bạn truy vấn một tập hợp các bản ghi (N) 
  # và sau đó cho mỗi bản ghi đó, bạn thực hiện một truy vấn bổ sung để lấy dữ liệu liên quan (1 truy vấn cho mỗi bản ghi).
  # Điều này dẫn đến tổng số truy vấn là N + 1
  # nó làm cho ứng dụng chậm hơn rất nhiều
  # Ví dụ: Lấy tất cả sinh viên và trạng thái của họ
  # Nếu không dùng includes, nó sẽ thực hiện 1 truy vấn để lấy tất cả sinh viên
  # và sau đó cho mỗi sinh viên, nó sẽ thực hiện thêm 1 truy vấn để lấy trạng thái của sinh viên đó
  # Nếu có 100 sinh viên, nó sẽ thực hiện 1 + 100 = 101 truy vấn
  # Nhưng nếu dùng includes(:status), nó sẽ thực hiện 1 truy vấn để lấy tất cả sinh viên
  # và 1 truy vấn để lấy tất cả trạng thái của các sinh viên đó
 # Tổng cộng chỉ có 2 truy vấn, giảm đáng kể số lượng truy vấn và cải thiện hiệu suất -> đó là lý do tại sao mình dùng includes
  scope :with_status, -> { includes(:status) }
  scope :with_user, -> { includes(:user) }
  scope :with_all_relations, -> { includes(:status, :user) }
  
  #  Scope ordering
  # sắp xếp theo tên và mới nhất trước
  # order là sắp xếp
  scope :by_name, -> { order(:full_name) }
  scope :newest_first, -> { order(created_at: :desc) }

  # :key và key: là cú pháp Ruby để định nghĩa các tham số trong hash
  # :key là ký hiệu (symbol) còn key: là cú pháp mới của Ruby
  # Chúng thường được sử dụng thay thế cho nhau trong các tình huống khác nhau
  # :key nó giống với việc bạn định nghĩa một biến hằng số
  # key: nó giống với việc bạn định nghĩa một biến thông thường
  # ví dụ : 
  # { key: "value" } # Đây là một hash với key là "key" và value là "value"
  # { :key => "value" } # Đây là một hash với key là :key và value là "value"
  # Trong các phương thức, bạn thường thấy cú pháp key: được sử dụng để định nghĩa các tham số có tên
  # def method_name(key: "default_value")
  # end
  # Cả hai cú pháp đều hợp lệ và có thể sử dụng thay thế cho nhau trong hầu hết các trường hợp
  # Tuy nhiên, cú pháp key: thường được ưu tiên sử dụng trong các phương thức để định nghĩa các tham số có tên vì nó rõ ràng hơn
  # Còn cú pháp :key thường được sử dụng trong các hash để định nghĩa các key

  #Ruby coi key: là :key => ...
  # { name: "Ninh", age: 21 } nó giống với { :name => "Ninh", :age => 21 }
  #   p :name          # => :name (symbol)

  # p { name: "Ninh" }  
  # # => {:name=>"Ninh"} (hash có 1 cặp key-value)
 

  

 


  # Hàm lấy thông tin sinh viên theo ID
  def self.getStudenInfo_By_Id(student_id)
    with_all_relations.find_by(id: student_id)
    # như này thì nó sẽ n+1 query
    # Student.includes(:status, :user).find_by(id: student_id) 
    # nó giống nhau
  end

  # Hàm lấy tất cả sinh viên
  def self.getAllStudent
    not_suspended.with_all_relations.by_name
    # Nó giống 
    # Student.not_suspended.includes(:status, :user).order(:full_name)
    # Nó sẽ trả ra tất cả sinh viên không bị suspend và sắp xếp theo tên
  end

  # Hàm tạo sinh viên
  def self.createStudent(students)
    # # Kiểm tra xem user đó có tồn tại hay không
    unless User.exists?(students[:user_id])
      return { success: false, message: "User not found", errors: ["User does not exist"] }
    end
    # # Kiểm tra xem user đã có student chưa
    # if exists?(user_id: students[:user_id])
    #   return { success: false, message: "User already has student account", errors: ["User already has a student record"] }
    # end
    # Gán trạng thái mặc định là Active (ID = 1) nếu không có
    students[:status_id] = 1 unless students[:status_id]
    
    # Tạo student - truyền object trực tiếp
    result = create(students.to_h) # Convert ActionController::Parameters to hash
    
    # Logic if/else đơn giản
    if result.persisted? # Trả về true nếu lưu thành công 
      # Trả về false nếu object đó chỉ mới nằm trong bộ nhớ (chưa save) hoặc đã bị destroy.
      { success: true, message: "Create Student Success", data: result }
    else
      { success: false, message: "Create Student Failed", errors: result.errors.full_messages }
    end
  end

  # Hàm cập nhật thông tin sinh viên
  def self.updateStudent(student_id, student_params)
    # Dùng scope not_suspended để chỉ update student không bị suspend
    student = not_suspended.find_by(id: student_id)
    if student
      if student.update(student_params)
        { success: true, message: "Update Student Success", data: student }
      else
        { success: false, message: "Update Student Failed", errors: student.errors.full_messages }
      end
    else
      { success: false, message: "Student Not Found", errors: ["No active student with ID #{student_id}"] }
    end
  end

  # Hàm xoá sinh viên ( xoá mềm)
  def self.deleteStudent(student_id)
    student = not_suspended.find_by(id: student_id)
    if student
      # Chuyển trạng thái qua ID 2 (Inactive)
      if student.update(status_id: 2)
        { success: true, message: "Delete Student Success", data: student }
      else
        { success: false, message: "Delete Student Failed", errors: student.errors.full_messages }
      end
    else
      { success: false, message: "Student Not Found", errors: ["No student with ID #{student_id}"] }
    end
  end

  # Hàm cập nhập lại sinh viên
  def self.restoreStudent(student_id)
    student = inactive.find_by(id: student_id)
    if student
      if student.update(status_id: 1)
        { success: true, message: "Restore Student Success", data: student }
      else
        { success: false, message: "Restore Student Failed", errors: student.errors.full_messages }
      end
    else
      { success: false, message: "Inactive Student Not Found", errors: ["No inactive student with ID #{student_id}"] }
    end
  end


  # === INSTANCE METHODS ===

  def full_info
    {
      id: id,
      name: full_name,
      student_code: student_code,
      major: major,
      class_study: class_study,
      academy_year: academy_year,
      status: status.status_name,
      status_description: status.description,
      user_id: user_id,
      birthday: birthday,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  # Kiểm tra trạng thái
  def is_active?
    status.status_name == 'Active'
  end

  def is_graduated?
    status.status_name == 'Graduated'
  end

  def is_suspended?
    status.status_name == 'Suspended'
  end

  #  Method kiểm tra inactive
  def is_inactive?
    status.status_name == 'Inactive'
  end

  # Soft delete instance method

  def soft_delete!
    update(status_id: 2) # Inactive
  end

  # Restore instance method  
  def restore!
    update(status_id: 1) # Active
  end

  # Cập nhật status
  def mark_as_graduated!
    update(status_id: 3) # Graduated
  end


  def mark_as_suspended!
    update(status_id: 4) # Suspended
  end
 
end


# Công thức viết scope thường dùng 
# scope :tên_scope, -> { điều_kiện_where }
# scope :tên_scope, ->(param) { điều_kiện_where_với_param }

# Các Patterns phổ biến 
# A. Status/State Scopes:
# scope :active, -> { where(active: true) }
# scope :inactive, -> { where(active: false) }
# scope :published, -> { where(status: 'published') }
# scope :draft, -> { where(status: 'draft') }

# B. Filter by Attribute Scopes:

# scope :by_[attribute], ->(value) { where([attribute]: value) if value.present? }

# # Ví dụ:
# scope :by_major, ->(major) { where(major: major) if major.present? }
# scope :by_year, ->(year) { where(academy_year: year) if year.present? }
# scope :by_status, ->(status_id) { where(status_id: status_id) if status_id.present? }



# C. Search Scopes:
# scope :search, ->(query) {
#   where("column1 ILIKE ? OR column2 ILIKE ?", "%#{query}%", "%#{query}%") if query.present?
# }

# # Ví dụ:
# scope :search, ->(query) {
#   where("full_name ILIKE ? OR student_code ILIKE ? OR email ILIKE ?", 
#         "%#{query}%", "%#{query}%", "%#{query}%") if query.present?
# }

# D. Date/Time Scopes:
# scope :created_today, -> { where(created_at: Date.current.all_day) }
# scope :created_this_week, -> { where(created_at: Date.current.beginning_of_week..Date.current.end_of_week) }
# scope :created_this_month, -> { where(created_at: Date.current.beginning_of_month..Date.current.end_of_month) }
# scope :created_this_year, -> { where(created_at: Date.current.beginning_of_year..Date.current.end_of_year) }
# scope :recent, -> { where('created_at >= ?', 1.month.ago) }
# scope :older_than, ->(date) { where('created_at < ?', date) }


# E. Ordering Scopes:
# scope :by_[column], -> { order([column]) }
# scope :newest_first, -> { order(created_at: :desc) }
# scope :oldest_first, -> { order(created_at: :asc) }

# # Ví dụ:
# scope :by_name, -> { order(:full_name) }
# scope :by_code, -> { order(:student_code) }

# F. Association/Eager Loading Scopes:
# scope :with_[association], -> { includes(:[association]) }
# scope :with_all_relations, -> { includes(:association1, :association2) }

# # Ví dụ:
# scope :with_status, -> { includes(:status) }
# scope :with_user, -> { includes(:user) }
# scope :with_all_relations, -> { includes(:status, :user, :courses) }


# G. Count/Aggregate Scopes:
# scope :with_[relation]_count, -> {
#   left_joins(:[relation])
#     .group('table_name.id')
#     .select('table_name.*, COUNT([relation].id) as [relation]_count')
# }

# # Ví dụ:
# scope :with_courses_count, -> {
#   left_joins(:student_classes)
#     .group('students.id')
#     .select('students.*, COUNT(student_classes.id) as courses_count')
# }
# 
#
#
# QUY TẮC VIẾT SCOPE
#  NÊN:
# Tên scope ngắn gọn, mô tả rõ chức năng
# Luôn kiểm tra if value.present? cho scope có parameter
# Sử dụng ILIKE cho PostgreSQL (case-insensitive)
# Group các scope theo chức năng
# Sử dụng includes để tránh N+1 query
# KHÔNG NÊN:
# Viết logic phức tạp trong scope
# Quên kiểm tra nil/empty cho parameter
# Hardcode giá trị
# Scope quá dài, khó đọc

#  KHÔNG NÊN:
# Viết logic phức tạp trong scope
# Quên kiểm tra nil/empty cho parameter
# Hardcode giá trị
# Scope quá dài, khó đọc


#  5. CÁCH SỬ DỤNG
# 
# ## Đơn lẻ
# Student.active
# Student.by_major("Computer Science")
# Student.search("John")

# # Kết hợp (chainable)
# Student.active
#        .by_major("Computer Science")
#        .recent
#        .with_all_relations
#        .by_name

# # Trong controller
# def index
#   students = Student.active
#                    .by_major(params[:major])
#                    .search(params[:search])
#                    .with_all_relations
#                    .page(params[:page])
# end



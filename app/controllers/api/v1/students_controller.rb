class Api::V1::StudentsController < ApplicationController
  # Authentication disabled for simple student management
  # before_action :require_teacher, only: [:create, :update]
  # before_action :require_admin, only: [:destroy, :create, :update]

  # GET /api/v1/students
  # Lấy danh sách tất cả sinh viên
  def index 
   begin
    # Lấy danh sách tất cả sinh viên
    students = Student.getAllStudent
     # Nếu có sinh viên thì trả về danh sách
     if students.present?
       render_success(
        message: "Get All Students Success", 
        data: students.map(&:full_info))  # ← THÊM .map(&:full_info) ở đây
     else
       render_success(
        message: "No Students Found", 
        data: [])
     end
   rescue => e
    render_error(message: "Failed to get students: #{e.message}")
   end
  end

  # GET /api/v1/students/:id
  # Lấy thông tin chi tiết của 1 sinh viên
  def show
    begin
      student = Student.getStudenInfo_By_Id(params[:id])
      if student
        render_success(
          message: "Get Student Info Success", 
          data: student.full_info)
      else
        render_not_found(
          message: "Student not found",
          errors: ["No student with ID #{params[:id]}"]
        )
      end
    rescue => e
      render_error(message: "Failed to get student info: #{e.message}")
    end
  end
  # POST /api/v1/students
  # Tạo sinh vien mới 
=begin
   Body params: 
  { student: 
    { 
      full_name, 
      student_code,
      major,
      class_study,
      academy_year,
      user_id, 
      status_id, 
      email, 
      phone, 
      address,
      birth_date 
    } 
  }
=end

  def create
    begin
      result = Student.createStudent(student_params)
      if result[:success]
        render_success(
          message: result[:message],
          data: result[:data].full_info,
          status: :created
        )
      else
         render_error(
          message: result[:message],
          errors: result[:errors]
        )
      end
    rescue => e
      render_error(message: "Failed to create student: #{e.message}")
    end
  end

  # PUT  /api/v1/students/:id
  # Cập nhật thông tin sinh viên
=begin
   Body params: 
  { student: 
    { 
      full_name, 
      student_code,
      major,
      class_study,
      academy_year,
      user_id, 
      status_id, 
      email, 
      phone, 
      address,
      birth_date 
    } 
  }
=end
  def update
    begin
      result = Student.updateStudent(params[:id], student_params)
      if result[:success]
        render_success(
          message: result[:message],
          data: result[:data].full_info
        )
      else
        render_error(
          message: result[:message],
          errors: result[:errors]
        )
      end
    rescue => e
      render_error(message: "Failed to update student: #{e.message}")
    end
  end


  # DELETE /api/v1/students/:id
  # Xoá mềm 1 sinh viên
 def destroy
    begin
      result = Student.deleteStudent(params[:id])
      
      if result[:success]
        render_success(message: result[:message])
      else
        render_error(
          message: result[:message],
          errors: result[:errors]
        )
      end
    rescue => e
      render_error(message: "Failed to delete student: #{e.message}")
    end
  end

  #  POST /api/v1/students/:id/restore
  # Khôi phục sinh viên đã bị xoá
  def restore 
    begin
      result = Student.restoreStudent(params[:id])

      if result[:success]
        render_success(
          message: result[:message],
          data: result[:data].full_info
        )
      else
        render_error(
          message: result[:message],
          errors: result[:errors]
        )
      end
    rescue => e
      render_error(message: "Failed to restore student: #{e.message}")
    end
  end
  private


  # Strong parameters cho sinh viên
  #Strong parameters cho sinh viên là gì ?
  # Strong parameters là một tính năng của Rails giúp bảo vệ ứng dụng khỏi các cuộc tấn công
  #mass assignment (gán giá trị hàng loạt) bằng cách chỉ cho phép các thuộc tính cụ thể được phép gán
  #giá trị từ các tham số đầu vào (thường là từ form hoặc API request).
  # Trong ví dụ này, phương thức student_params sử dụng strong parameters để chỉ cho phép các thuộc tính sau của đối tượng Student 
  #được phép gán giá trị: full_name, student_code, major, birthday, class_study, academy_year, user_id, status_id.
  # Điều này giúp đảm bảo rằng chỉ những thuộc tính này mới có thể được cập nhật 
  #hoặc tạo mới thông qua các yêu cầu HTTP, ngăn chặn việc gán giá trị cho các thuộc tính không mong muốn hoặc nhạy cảm.
  # Cách sử dụng strong parameters:
  # Khi bạn nhận được một yêu cầu HTTP (ví dụ: POST hoặc PUT) để tạo hoặc cập nhật một đối tượng Student, 
  #bạn sẽ gọi phương thức student_params để lấy các tham số đã được lọc.
  # Ví dụ: params.require(:student).permit(...) sẽ yêu cầu rằng tham số :student phải tồn tại 
  #và chỉ cho phép các thuộc tính được liệt kê trong permit.
  # Sau đó, bạn có thể sử dụng kết quả của student_params để tạo hoặc cập nhật đối tượng Student một cách an toàn.
  # Ví dụ:
  # student = Student.new(student_params)
  # Hoặc:
  # student.update(student_params)  
  def student_params
    params.require(:student).permit(
      :full_name,
      :student_code,
      :major,
      :birthday,
      :class_study,
      :academy_year,
      :user_id, :status_id 
    )
  end
end

module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
    attr_reader :current_user
  end

  private

  # Method để authentication bắt buộc
  def authenticate_user
    # Lấy token từ header Authorization
    token = extract_token
    # Nếu không có token thì trả về lỗi 401
    return render_unauthorized('Missing token') unless token
    # Giải mã token và tìm user
    begin
      decoded = JwtService.decode_token(token)
      # tìm user theo user_id trong token
      @current_user = User.find(decoded[:user_id])
      # gán role từ token (nếu có)
      @current_user.role = decoded[:role] if decoded[:role]
    rescue ActiveRecord::RecordNotFound
      render_unauthorized('User not found')
    rescue StandardError => e
      render_unauthorized(e.message)
    end
  end


  # Method kiểm tra role
  def require_admin
     render_unauthorized('Admin access required') unless @current_user&.role == 'admin'
  end

  def require_teacher
     render_unauthorized('Teacher access required') unless @current_user&.role == 'teacher'
  end

end
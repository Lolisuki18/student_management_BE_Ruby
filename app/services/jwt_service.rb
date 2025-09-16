# Service để tạo và giải mã JWT token
class JwtService
  SECRET_KEY = ENV['JWT_SECRET_KEY'] || Rails.application.credentials.secret_key_base
  EXPIRATION_HOURS = (ENV['JWT_EXPIRATION_HOURS'] || 24).to_i

  # Tạo JWT token với payload và thời gian hết hạn
  # payload: hash chứa thông tin muốn mã hóa
  # exp: thời gian hết hạn (mặc định 24 giờ)
  # ta lấy thời gian hiện tại + số giờ từ biến môi trường
  #trả về token đã mã hoá dưới dạng chuỗi
  def self.encode(payload, exp = EXPIRATION_HOURS.hours.from_now)
    full_payload = payload.merge(meta.merge(exp: exp.to_i))
    JWT.encode(full_payload, SECRET_KEY, 'HS256')
  end

  # Giải mã JWT token
  # token: chuỗi token cần giải mã
  # trả về payload đã giải mã dưới dạng hash
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    raise StandardError, "Invalid token: #{e.message}"
  rescue JWT::ExpiredSignature => e
    raise StandardError, "Token has expired: #{e.message}"
  rescue => e
    raise StandardError, "Token error: #{e.message}"
  end

  #Bởi vì JWT không lưu trạng thái, nên ta cần tự kiểm tra tính hợp lệ của payload
  # Tạo check xem token có hợp lệ không
  def self.valid_payload?(payload)
    return false if expired(payload)
    return false if payload['iss'] != meta[:iss]
    return false if payload['aud'] != meta[:aud]
    true
  end

  # Hàm check xem token còn thời gian không
  def self.expired(payload)
    return true if Time.at(payload['exp']) < Time.now
    false
  end

  # Thông tin meta để xác thực token
  # iss: issuer (người phát hành)
  # aud: audience (đối tượng sử dụng)
  # iat: issued at (thời gian phát hành)
  def self.meta
    {
      iss: 'StudentManagementAPI',
      aud: 'client',
      iat: Time.now.to_i
    }
  end

  # Tạo token mới với user_id và role
  # role mặc định là 'student'
  def self.generate_token(user_id, role ='student')
    payload = {
      user_id: user_id,
      role: role
    }
    encode(payload)
  end
  
  # Tạo token mới dựa trên token cũ (refresh token)
  def self.refresh_token(old_token)
    payload = decode(old_token)
    # Xóa exp cũ để tạo exp mới
    payload.except('exp', 'iat')
    encode(payload)
  rescue => e
    raise StandardError, "Cannot refresh token: #{e.message}"
  end
  
end

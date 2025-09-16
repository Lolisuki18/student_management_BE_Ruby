class ApplicationController < ActionController::API
  # Authentication disabled for simple student management
  # include Authenticatable

  protected

  # method dùng để render JSON success response
  def render_success(message: 'Success', data: nil, status: :ok)
    render json: {
      success: true,
      message: message,
      data: data
    }, status: status
  end

  #  method dùng để render JSON error response
  def render_error(message: 'Error', errors: [], status: :unprocessable_entity)
    render json: {
      success: false,
      message: message,
      errors: errors
    }, status: status
  end

  # Method dùng  để render JSON not found response
  def render_not_found(message: 'Not Found', errors: [])
    render json: {
      success: false,
      message: message,
      errors: errors
    }, status: :not_found
  end

  # method dùng để render JSON unauthorized response
  def render_unauthorized(message: 'Unauthorized')
    render json: {
      success: false,
      message: message,
      errors: [message]
    }, status: :unauthorized
  end
end

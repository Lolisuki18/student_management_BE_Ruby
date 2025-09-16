# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Cho phép tất cả origins trong development
    origins '*'
    
    # Hoặc chỉ định cụ thể cho production
    # origins 'http://localhost:3000', 'https://yourdomain.com'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false
       # Giữ true nếu dùng origins cụ thể
      # credentials: false  # Dùng false nếu origins '*
  end
end

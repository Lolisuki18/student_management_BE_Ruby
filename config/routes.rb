Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :students do
        member do
          post :restore # POST /api/v1/students/:id/restore
        end
      end
    end
  end
end

=begin 
  Routes là gì ? 
 Routes là bản đồ đường đi - nó cho Rails biết 
 -> URL nào -> Gọi Controller nào? -> Action nào? 

 namespace :api do
  namespace :v1 do
    # Tạo URL prefix: /api/v1/...
  end
end
 -> kết quả là tất cả URL sẽ bắt đầu bằng /api/v1/...

 resources :students do
  member do
    post :restore  # POST /api/v1/students/:id/restore
  end
end
 -> member: các routes áp dụng cho một tài nguyên cụ thể, yêu cầu ID của tài nguyên đó.
 -> ví dụ: /api/v1/students/123/restore

 resources :students do
  collection do
    get :search   # GET /api/v1/students/search?q=query
  end
end
 -> collection: các routes áp dụng cho toàn bộ tập hợp tài nguyên, không yêu cầu ID cụ thể.
 -> ví dụ: /api/v1/students/search

 resources :students do
  member do
    post :restore     # /api/v1/students/123/restore
    patch :suspend    # /api/v1/students/123/suspend
    get :profile      # /api/v1/students/123/profile
  end
end
 -> Thêm nhiều routes tùy chỉnh cho từng sinh viên cụ thể.

 resources :students do
  collection do
    get :search       # /api/v1/students/search
    get :export       # /api/v1/students/export
    post :import      # /api/v1/students/import
  end
end
 -> Thêm các routes tùy chỉnh áp dụng cho toàn bộ tập hợp sinh viên.


 resources :students -> sẽ tự tạo 7 routes chuẩn  cho students

 HTTP Method	URL	Controller#Action	Mục đích
GET |	/api/v1/students	 |students#index	 | Lấy danh sách
GET	| /api/v1/students/new	| students#new |	 Form tạo mới
POST|	/api/v1/students	 | students#create |Tạo mới
GET	| /api/v1/students/:id	| students#show	| Xem 1 student
GET	| /api/v1/students/:id/edit | 	students#edit	 | Form edit
PATCH/PUT |	/api/v1/students/:id |	students#update	| Cập nhật
DELETE	| /api/v1/students/:id |	students#destroy |	Xóa

3. Member routes:
  -> Áp dụng cho một tài nguyên cụ thể, yêu cầu ID của tài nguyên đó.

  member do
    post :restore  # POST /api/v1/students/:id/restore
  end

  Member = cần ID cụ thể của student

  URL: /api/v1/students/123/restore
  Controller: students#restore
  Dùng cho: action áp dụng cho 1 student cụ thể

  Collection routes -> 
  collection do
    get :search   # GET /api/v1/students/search?q=query
  end

  Collection = KHÔNG cần ID, áp dụng cho toàn bộ collection

  URL: /api/v1/students/search?q=john
  Controller: students#search
  Dùng cho: action áp dụng cho tất cả students


  So sánh Member vs Collection:
  Member (cần ID):
    member do
      post :restore     # /api/v1/students/123/restore
      patch :suspend    # /api/v1/students/123/suspend
      get :profile      # /api/v1/students/123/profile
    end
  Collection (không cần ID):
    collection do
      get :search       # /api/v1/students/search
      get :export       # /api/v1/students/export
      post :import      # /api/v1/students/import
    end

    Chạy lệnh này để xem tất cả routes:
    rails routes
=end

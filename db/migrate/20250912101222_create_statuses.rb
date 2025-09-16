class CreateStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :statuses do |t|
      t.string :status_name, null: false
      t.text :description 
      t.timestamps
    end
    add_index :statuses, :status_name, unique: true # cấm trùng lặp
  end
end

#  :key (dấu : ở trước)

# Đây là symbol độc lập.

# Không gán giá trị gì cả, chỉ tạo ra một "nhãn" (immutable string).

# :user_name   # => :user_name
# :email       # => :email
# 👉 Dùng khi bạn muốn truyền tham số hoặc định danh một cái gì đó (vd: tên cột, tên bảng).

# key: (dấu : ở sau)

# Đây là hash key trong cú pháp hash mới của Ruby (Ruby 1.9+).

# Luôn đi kèm với một giá trị.

# user_name: "Ninh"
# email: "abc@gmail.com"

# Ruby sẽ hiểu thành:

# { :user_name => "Ninh", :email => "abc@gmail.com" }

# 🚀 So sánh nhanh
# Cú pháp	Ý nghĩa	Ví dụ
# :email	Symbol độc lập (chỉ là nhãn)	add_index :users, :email
# email:	Symbol đóng vai trò key trong hash	t.string :email, null: false
# email: "A"	Hash với key là :email, value là "A"	{ email: "A" } # => {:email=>"A"}
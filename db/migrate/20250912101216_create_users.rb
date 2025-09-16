class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :user_name, null: false
      t.string :password_digest , null: false
      t.string :phone
      t.string :email
      t.boolean :active, default: true
      t.references :role, null: false, foreign_key: true
      t.timestamps
    end
# add_index :users, [:user_name, :email], unique: true
#->Viết như này có nghĩa là cặp user_name và email không được trùng lặp
#->Nhưng user_name có thể trùng lặp, email có thể trùng lặp

    add_index :users, :user_name, unique: true
    add_index :users, :email, unique: true
  end
end

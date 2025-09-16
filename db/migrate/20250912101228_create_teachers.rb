class CreateTeachers < ActiveRecord::Migration[8.0]
  def change
    create_table :teachers do |t|
      t.string :full_name, null: false
      t.string :teacher_code, null: false
      t.references :user, null: false, foreign_key: true
      t.date :birthday
      t.string :phone
      t.string :email
      t.text :description
      t.string :department
      t.timestamps
    end
    add_index :teachers, :teacher_code, unique: true # cấm trùng lặp
    add_index :teachers, :email, unique: true # cấm trùng lặp
  end
end

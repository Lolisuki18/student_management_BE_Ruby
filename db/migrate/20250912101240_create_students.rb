class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :full_name, null: false
      t.string :student_code, null: false
      t.string :major
      t.date :birthday
      t.string :class_study
      t.string :academy_year
      t.references :user, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true

      t.timestamps
    end

    add_index :students, :student_code, unique: true
  end
end

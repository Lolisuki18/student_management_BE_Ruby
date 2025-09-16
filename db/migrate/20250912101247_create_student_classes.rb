class CreateStudentClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :student_classes do |t|
      t.references :student, null: false, foreign_key: true
      t.references :class, null: false, foreign_key: { to_table: :classes }
      t.datetime :enrolled_at
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :student_classes, [:student_id, :class_id], unique: true
  end
end
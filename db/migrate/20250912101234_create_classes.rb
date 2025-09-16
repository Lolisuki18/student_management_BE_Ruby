class CreateClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :classes do |t|
      t.string :name_class , null: false 
      t.string :class_code , null: false
      t.references :teacher, null: false, foreign_key: true
      t.text :description
      t.integer :student_limit
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :classes, :class_code, unique: true # cấm trùng lặp
  end
end

class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :role_name, null:false 
      t.text :description 
      t.boolean :active, default:true
      t.timestamps
    end
    add_index :roles, :role_name, unique: true # cấm trùng lặp
  end
end

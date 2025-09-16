# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_12_101247) do
  create_table "classes", force: :cascade do |t|
    t.string "name_class", null: false
    t.string "class_code", null: false
    t.bigint "teacher_id", null: false
    t.text "description"
    t.integer "student_limit"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_code"], name: "index_classes_on_class_code", unique: true
    t.index ["teacher_id"], name: "index_classes_on_teacher_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role_name", null: false
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_name"], name: "index_roles_on_role_name", unique: true
  end

  create_table "statuses", force: :cascade do |t|
    t.string "status_name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_name"], name: "index_statuses_on_status_name", unique: true
  end

  create_table "student_classes", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "class_id", null: false
    t.datetime "enrolled_at"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_id"], name: "index_student_classes_on_class_id"
    t.index ["student_id", "class_id"], name: "index_student_classes_on_student_id_and_class_id", unique: true
    t.index ["student_id"], name: "index_student_classes_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "student_code", null: false
    t.string "major"
    t.date "birthday"
    t.string "class_study"
    t.string "academy_year"
    t.bigint "user_id", null: false
    t.bigint "status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_students_on_status_id"
    t.index ["student_code"], name: "index_students_on_student_code", unique: true
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "teacher_code", null: false
    t.bigint "user_id", null: false
    t.date "birthday"
    t.string "phone"
    t.string "email"
    t.text "description"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["teacher_code"], name: "index_teachers_on_teacher_code", unique: true
    t.index ["user_id"], name: "index_teachers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "password_digest", null: false
    t.string "phone"
    t.string "email"
    t.boolean "active", default: true
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

  add_foreign_key "classes", "teachers"
  add_foreign_key "student_classes", "classes"
  add_foreign_key "student_classes", "students"
  add_foreign_key "students", "statuses"
  add_foreign_key "students", "users"
  add_foreign_key "teachers", "users"
  add_foreign_key "users", "roles"
end

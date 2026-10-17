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

ActiveRecord::Schema[8.1].define(version: 2026_10_17_134428) do
  create_table "activities", force: :cascade do |t|
    t.integer "activity_group_id", null: false
    t.string "nombre", null: false
    t.index ["activity_group_id"], name: "index_activities_on_activity_group_id"
  end

  create_table "activity_groups", force: :cascade do |t|
    t.string "nombre", null: false
  end

  create_table "extra_activities", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
  end

  create_table "import_errors", force: :cascade do |t|
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legacy_files_parsers", force: :cascade do |t|
    t.string "parser_name"
    t.string "row_number"
    t.string "nombres"
    t.string "activity_group_str"
    t.string "activity_str"
    t.string "activity_dates"
    t.string "duracion"
    t.integer "start_date_index_from"
    t.integer "start_date_index_to"
    t.integer "end_date_index_from"
    t.integer "end_date_index_to"
    t.string "sheet_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legacy_person_activities", force: :cascade do |t|
    t.integer "row_number"
    t.string "nombres", null: false
    t.string "activity_group_str"
    t.string "activity_str"
    t.string "activity_dates"
    t.string "duracion"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "nombres", null: false
    t.string "dni"
    t.string "pabellon"
    t.integer "estado", default: 0
  end

  create_table "person_activities", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "coursable_id", null: false
    t.integer "mes", null: false
    t.integer "anio", null: false
    t.integer "cargo", default: 0
    t.string "qty_h"
    t.string "coursable_type"
    t.index ["coursable_id"], name: "index_person_activities_on_coursable_id"
    t.index ["coursable_type", "coursable_id"], name: "index_person_activities_on_coursable_type_and_coursable_id"
    t.index ["person_id"], name: "index_person_activities_on_person_id"
  end

  create_table "person_pabellon_updates", force: :cascade do |t|
    t.string "nombres"
    t.string "pabellon"
    t.datetime "created_at", null: false
  end

  add_foreign_key "activities", "activity_groups"
  add_foreign_key "person_activities", "activities", column: "coursable_id"
  add_foreign_key "person_activities", "people"
end

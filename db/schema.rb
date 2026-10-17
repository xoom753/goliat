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

ActiveRecord::Schema[8.1].define(version: 2026_10_17_222601) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "legacy_activities", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "legacy_activity_groups", force: :cascade do |t|
    t.string "nombre"
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
    t.string "file_format"
  end

  create_table "legacy_import_files", force: :cascade do |t|
    t.string "filename"
    t.string "filepath"
    t.string "last_modified_at"
    t.integer "legacy_files_parser_id"
    t.integer "status", default: 0
    t.integer "duplicate_of_id"
    t.string "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["legacy_files_parser_id"], name: "index_legacy_import_files_on_legacy_files_parser_id"
  end

  create_table "legacy_people", force: :cascade do |t|
    t.string "nombres", null: false
    t.string "dni"
    t.datetime "created_at", null: false
    t.index ["nombres"], name: "index_legacy_people_on_nombres"
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
    t.integer "legacy_person_id"
    t.integer "legacy_activity_id"
    t.integer "legacy_activity_group_id"
    t.index ["legacy_activity_group_id"], name: "index_legacy_person_activities_on_legacy_activity_group_id"
    t.index ["legacy_activity_id"], name: "index_legacy_person_activities_on_legacy_activity_id"
    t.index ["legacy_person_id"], name: "index_legacy_person_activities_on_legacy_person_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "activity_groups"
  add_foreign_key "legacy_import_files", "legacy_files_parsers"
  add_foreign_key "legacy_person_activities", "legacy_activities"
  add_foreign_key "legacy_person_activities", "legacy_activity_groups"
  add_foreign_key "legacy_person_activities", "legacy_people"
  add_foreign_key "person_activities", "activities", column: "coursable_id"
  add_foreign_key "person_activities", "people"
end

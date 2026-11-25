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

ActiveRecord::Schema[8.1].define(version: 2026_11_24_201726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.text "name"
    t.text "record_type"
    t.bigint "record_id"
    t.bigint "blob_id"
    t.timestamptz "created_at"
    t.index ["blob_id"], name: "idx_16440_index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "idx_16440_index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.text "key"
    t.text "filename"
    t.text "content_type"
    t.text "metadata"
    t.text "service_name"
    t.bigint "byte_size"
    t.text "checksum"
    t.timestamptz "created_at"
    t.index ["key"], name: "idx_16433_index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id"
    t.text "variation_digest"
    t.index ["blob_id", "variation_digest"], name: "idx_16447_index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.bigint "activity_group_id"
    t.text "nombre"
    t.index ["activity_group_id"], name: "idx_16402_index_activities_on_activity_group_id"
  end

  create_table "activity_groups", force: :cascade do |t|
    t.text "nombre"
  end

  create_table "activity_human_names", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.string "nombre", null: false
    t.datetime "created_at"
    t.index ["activity_id"], name: "index_activity_human_names_on_activity_id"
  end

  create_table "extra_activities", force: :cascade do |t|
    t.text "nombre"
    t.timestamptz "created_at"
  end

  create_table "extranjero_presentes", force: :cascade do |t|
    t.text "nombres"
    t.text "pasaporte"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
  end

  create_table "import_errors", force: :cascade do |t|
    t.text "details"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
  end

  create_table "legacy_activities", force: :cascade do |t|
    t.text "nombre"
    t.timestamptz "created_at"
    t.index ["nombre"], name: "idx_16468_index_legacy_activities_on_nombre"
  end

  create_table "legacy_activity_details", force: :cascade do |t|
    t.text "nombre"
    t.timestamptz "created_at"
    t.index ["nombre"], name: "idx_16482_index_legacy_activity_details_on_nombre"
  end

  create_table "legacy_activity_groups", force: :cascade do |t|
    t.text "nombre"
    t.timestamptz "created_at"
    t.bigint "activity_group_id"
    t.index ["activity_group_id"], name: "idx_16475_index_legacy_activity_groups_on_activity_group_id"
    t.index ["nombre"], name: "idx_16475_index_legacy_activity_groups_on_nombre"
  end

  create_table "legacy_course_file_parsers", force: :cascade do |t|
    t.text "parser_name"
    t.text "description"
    t.bigint "skip_rows"
    t.bigint "nombres_col"
    t.text "fechas_cols"
    t.text "file_format"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.text "sheet_numbers"
    t.integer "emtpy_rows_for_footer_count"
    t.boolean "month_name_in_each_sheet"
    t.text "ignore_specific_rows"
  end

  create_table "legacy_files_parsers", force: :cascade do |t|
    t.text "parser_name"
    t.text "row_number"
    t.text "nombres"
    t.text "activity_group_str"
    t.text "activity_str"
    t.text "activity_dates"
    t.text "duracion"
    t.bigint "start_date_index_from"
    t.bigint "start_date_index_to"
    t.bigint "end_date_index_from"
    t.bigint "end_date_index_to"
    t.text "sheet_name"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.text "file_format"
    t.text "activity_detail_str"
    t.text "description"
    t.string "default_activity_group_str"
  end

  create_table "legacy_import_files", force: :cascade do |t|
    t.text "filename"
    t.text "filepath"
    t.text "last_modified_at"
    t.bigint "parseable_id"
    t.bigint "status", default: 0
    t.bigint "duplicate_of_id"
    t.text "weight"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.text "parseable_type"
    t.bigint "records_count"
    t.bigint "year"
    t.bigint "month"
    t.text "records_list"
    t.date "override_hasta"
    t.index ["filename", "last_modified_at", "weight", "id"], name: "idx_16538_idx_on_filename_last_modified_at_weight_id_5994fea729"
    t.index ["last_modified_at", "filename"], name: "idx_16538_index_legacy_import_files_on_last_modified_at_and_fil"
    t.index ["parseable_id"], name: "idx_16538_index_legacy_import_files_on_parseable_id"
    t.index ["year", "month"], name: "idx_16538_index_legacy_import_files_on_year_and_month"
  end

  create_table "legacy_people", force: :cascade do |t|
    t.text "nombres"
    t.text "dni"
    t.timestamptz "created_at"
    t.index ["nombres"], name: "idx_16454_index_legacy_people_on_nombres"
  end

  create_table "legacy_person_activities", force: :cascade do |t|
    t.bigint "row_number"
    t.text "activity_dates"
    t.text "duracion"
    t.date "start_date"
    t.date "end_date"
    t.timestamptz "created_at"
    t.bigint "legacy_person_id"
    t.bigint "legacy_activity_id"
    t.bigint "legacy_activity_group_id"
    t.bigint "legacy_activity_detail_id"
    t.bigint "legacy_import_file_id"
    t.index ["end_date"], name: "idx_16489_index_legacy_person_activities_on_end_date"
    t.index ["legacy_activity_detail_id"], name: "idx_16489_index_legacy_person_activities_on_legacy_activity_det"
    t.index ["legacy_activity_group_id"], name: "idx_16489_index_legacy_person_activities_on_legacy_activity_gro"
    t.index ["legacy_activity_id"], name: "idx_16489_index_legacy_person_activities_on_legacy_activity_id"
    t.index ["legacy_person_id"], name: "idx_16489_index_legacy_person_activities_on_legacy_person_id"
  end

  create_table "origin_people", force: :cascade do |t|
    t.date "fecha_registro"
    t.text "father_lastname"
    t.text "mother_lastname"
    t.text "first_name"
    t.text "middle_name"
    t.text "fullname"
    t.text "alias_name"
    t.text "dni_kind"
    t.text "dni"
    t.bigint "situacion_actual", default: 0
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.integer "sexo"
    t.index ["dni"], name: "idx_16503_index_origin_people_on_dni"
    t.index ["fullname", "dni"], name: "idx_16503_index_origin_people_on_fullname_and_dni"
    t.index ["fullname"], name: "idx_16503_index_origin_people_on_fullname"
    t.index ["situacion_actual"], name: "index_origin_people_on_situacion_actual"
  end

  create_table "origin_person_demographics", force: :cascade do |t|
    t.text "pais_origen"
    t.date "fecha_nacimiento"
    t.text "estado_civil"
    t.text "nivel_instruccion"
    t.text "profesion"
    t.text "gravedad_enfermedad"
    t.text "tipo_enfermedad"
    t.text "tipo_discapacidad"
    t.bigint "origin_person_id"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.index ["origin_person_id"], name: "idx_16511_index_origin_person_demographics_on_origin_person_id"
  end

  create_table "origin_person_legal_penalties", force: :cascade do |t|
    t.bigint "anios_acumulacion_pena"
    t.bigint "meses_acumulacion_pena"
    t.bigint "dias_acumulacion_pena"
    t.bigint "acumulacion_total_penas"
    t.bigint "anios_pena_individual"
    t.bigint "meses_pena_individual"
    t.bigint "dias_pena_individual"
    t.bigint "acumulacion_pena_individual_total"
    t.bigint "cantidad_total_sentencia"
    t.date "termina_condena_at"
    t.date "veinte_porciento_at"
    t.date "cuarenta_porciento_at"
    t.date "sesenta_porciento_at"
    t.date "ochenta_porciento_at"
    t.bigint "origin_person_id"
    t.bigint "origin_person_legal_process_id"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.index ["origin_person_id"], name: "idx_16526_index_origin_person_legal_penalties_on_origin_person_"
    t.index ["origin_person_legal_process_id"], name: "idx_16526_idx_on_origin_person_legal_process_id_796970cb62"
  end

  create_table "origin_person_legal_processes", force: :cascade do |t|
    t.date "fecha_detencion"
    t.date "fecha_delito"
    t.date "fecha_ingreso"
    t.bigint "estado", default: 0
    t.bigint "anios_sentencia"
    t.bigint "meses_sentencia"
    t.bigint "dias_sentencia"
    t.date "fecha_sentencia"
    t.text "boleta_encarcelamiento"
    t.date "fecha_boleta_encarcelamiento"
    t.text "proceso_num"
    t.text "normativa"
    t.text "infraccion"
    t.text "incisos"
    t.text "grupo_infraccion"
    t.text "subgrupo_infraccion"
    t.text "parte_policial_num"
    t.text "observaciones"
    t.text "observaciones_2"
    t.bigint "origin_person_id"
    t.timestamptz "created_at"
    t.timestamptz "updated_at"
    t.index ["origin_person_id"], name: "idx_16518_index_origin_person_legal_processes_on_origin_person_"
    t.index ["proceso_num"], name: "idx_16518_index_origin_person_legal_processes_on_proceso_num"
  end

  create_table "people", force: :cascade do |t|
    t.text "nombres"
    t.text "dni"
    t.string "pabellon"
    t.bigint "estado", default: 0
    t.string "celda"
    t.index ["dni"], name: "idx_16394_index_people_on_dni"
    t.index ["estado"], name: "index_people_on_estado"
    t.index ["nombres"], name: "idx_16394_index_people_on_nombres"
  end

  create_table "person_activities", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "coursable_id"
    t.bigint "mes"
    t.bigint "anio"
    t.bigint "cargo", default: 0
    t.text "qty_h"
    t.text "coursable_type"
    t.index ["coursable_id"], name: "idx_16546_index_person_activities_on_coursable_id"
    t.index ["coursable_type", "coursable_id"], name: "idx_16546_index_person_activities_on_coursable_type_and_coursab"
    t.index ["person_id"], name: "idx_16546_index_person_activities_on_person_id"
  end

  create_table "person_ejes_resumenes", force: :cascade do |t|
    t.string "nombres"
    t.string "dni"
    t.date "fecha_perdida_libertad"
    t.text "delitos"
    t.text "sentencias"
    t.text "acumulacion_penas"
    t.text "semestres_porcentuales"
    t.text "periodos_detalle"
    t.timestamptz "created_at"
    t.string "ubicacion"
    t.date "fecha_traslado"
    t.string "ubicacion_traslado"
    t.text "legacy_people_ids"
    t.boolean "tipo_porcentual"
    t.text "people_ids"
    t.timestamptz "last_generated_at"
    t.text "fechas_ingresos_y_egresos"
    t.integer "primer_semestre_index"
    t.string "primer_semestre_porcentaje"
  end

  create_table "person_pabellon_updates", force: :cascade do |t|
    t.text "nombres"
    t.text "pabellon"
    t.timestamptz "created_at"
    t.string "celda"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id", name: "active_storage_attachments_blob_id_fkey"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id", name: "active_storage_variant_records_blob_id_fkey"
  add_foreign_key "activities", "activity_groups", name: "activities_activity_group_id_fkey"
  add_foreign_key "activity_human_names", "activities"
  add_foreign_key "legacy_activity_groups", "activity_groups", name: "legacy_activity_groups_activity_group_id_fkey"
  add_foreign_key "legacy_person_activities", "legacy_activities", name: "legacy_person_activities_legacy_activity_id_fkey"
  add_foreign_key "legacy_person_activities", "legacy_activity_details", name: "legacy_person_activities_legacy_activity_detail_id_fkey"
  add_foreign_key "legacy_person_activities", "legacy_activity_groups", name: "legacy_person_activities_legacy_activity_group_id_fkey"
  add_foreign_key "legacy_person_activities", "legacy_people", name: "legacy_person_activities_legacy_person_id_fkey"
  add_foreign_key "origin_person_demographics", "origin_people", name: "origin_person_demographics_origin_person_id_fkey"
  add_foreign_key "origin_person_legal_penalties", "origin_people", name: "origin_person_legal_penalties_origin_person_id_fkey"
  add_foreign_key "origin_person_legal_penalties", "origin_person_legal_processes", name: "origin_person_legal_penalties_origin_person_legal_process__fkey"
  add_foreign_key "origin_person_legal_processes", "origin_people", name: "origin_person_legal_processes_origin_person_id_fkey"
  add_foreign_key "person_activities", "people", name: "person_activities_person_id_fkey"
end

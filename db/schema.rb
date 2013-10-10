# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131010144032) do

  create_table "configuracions", :force => true do |t|
    t.string   "xbee_port"
    t.string   "xbee_pan_id"
    t.string   "xbee_channel"
    t.string   "xbee_key"
    t.string   "xbee_mac"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "datos", :force => true do |t|
    t.integer  "dispositivo_id"
    t.datetime "fecha"
    t.decimal  "valor",          :precision => 10, :scale => 2
    t.integer  "variable_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dispositivos", :force => true do |t|
    t.string   "mac"
    t.string   "identificador"
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "ultima_comunicacion"
    t.string   "tipo"
    t.string   "software_ejecutando"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "dispositivos_programas", :id => false, :force => true do |t|
    t.integer "dispositivo_id"
    t.integer "programa_id"
  end

  create_table "imagens", :force => true do |t|
    t.string   "imagen_p_file_name"
    t.string   "imagen_p_content_type"
    t.integer  "imagen_p_file_size"
    t.datetime "imagen_p_updated_at"
    t.string   "imagen_1_file_name"
    t.string   "imagen_1_content_type"
    t.integer  "imagen_1_file_size"
    t.datetime "imagen_1_updated_at"
    t.string   "imagen_2_file_name"
    t.string   "imagen_2_content_type"
    t.integer  "imagen_2_file_size"
    t.datetime "imagen_2_updated_at"
    t.text     "descripcion"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.datetime "fecha"
  end

  create_table "metadatos", :force => true do |t|
    t.integer  "dispositivo_id"
    t.integer  "rssi"
    t.integer  "battery"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "programas", :force => true do |t|
    t.string   "nombre"
    t.string   "tipo"
    t.text     "descripcion"
    t.string   "codigo_fuente_file_name"
    t.string   "codigo_fuente_content_type"
    t.integer  "codigo_fuente_file_size"
    t.datetime "codigo_fuente_updated_at"
    t.string   "compilado_file_name"
    t.string   "compilado_content_type"
    t.integer  "compilado_file_size"
    t.datetime "compilado_updated_at"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "codigo"
  end

  create_table "transmisions", :force => true do |t|
    t.date     "desde_fecha"
    t.date     "hasta_fecha"
    t.datetime "fecha"
    t.string   "origen"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "variables", :force => true do |t|
    t.string   "codigo"
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end

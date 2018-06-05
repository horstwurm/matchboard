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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180529152638) do

  create_table "appparams", force: :cascade do |t|
    t.string   "domain"
    t.string   "parent_domain"
    t.string   "right"
    t.boolean  "access"
    t.string   "info"
    t.float    "fee"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "appparam_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "stripe_id"
    t.string   "topic"
    t.string   "plan"
    t.float    "amount"
    t.date     "date_from"
    t.date     "date_to"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "status"
    t.boolean  "active"
    t.boolean  "partner"
    t.string   "name"
    t.integer  "mcategory_id"
    t.string   "stichworte"
    t.string   "homepage"
    t.integer  "user_id"
    t.text     "description"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "geo_address"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["mcategory_id"], name: "index_companies_on_mcategory_id"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "company_params", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "claim"
    t.string   "logo"
    t.string   "color1"
    t.string   "color2"
    t.string   "color3"
    t.string   "color4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credentials", force: :cascade do |t|
    t.integer  "appparam_id"
    t.integer  "user_id"
    t.boolean  "access"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["appparam_id"], name: "index_credentials_on_appparam_id"
    t.index ["user_id"], name: "index_credentials_on_user_id"
  end

  create_table "deputies", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "userid"
    t.date     "date_from"
    t.date     "date_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favourits", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "object_name"
    t.integer  "object_id"
    t.integer  "category"
    t.string   "stichworte"
    t.boolean  "email"
    t.boolean  "ticker"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_favourits_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "mobject_id"
    t.integer  "user_id"
    t.string   "modus"
    t.integer  "mcategory_id"
    t.string   "courtnumber"
    t.string   "player1"
    t.string   "player2"
    t.string   "player3"
    t.string   "player4"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "madvisors", force: :cascade do |t|
    t.integer  "mobject_id"
    t.integer  "user_id"
    t.string   "grade"
    t.float    "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "role"
    t.index ["mobject_id"], name: "index_madvisors_on_mobject_id"
    t.index ["user_id"], name: "index_madvisors_on_user_id"
  end

  create_table "mcategories", force: :cascade do |t|
    t.string   "name"
    t.string   "ctype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mdetails", force: :cascade do |t|
    t.integer  "mobject_id"
    t.string   "mtype"
    t.string   "name"
    t.string   "status"
    t.integer  "sequence"
    t.text     "description"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.index ["mobject_id"], name: "index_mdetails_on_mobject_id"
  end

  create_table "mobjects", force: :cascade do |t|
    t.string   "mtype"
    t.integer  "mcategory_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "status"
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.boolean  "online_pub"
    t.string   "keywords"
    t.string   "homepage"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "geo_address"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["mcategory_id"], name: "index_mobjects_on_mcategory_id"
    t.index ["mtype"], name: "index_mobjects_on_mtype"
    t.index ["owner_id"], name: "index_mobjects_on_owner_id"
    t.index ["owner_type"], name: "index_mobjects_on_owner_type"
  end

  create_table "partner_links", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.text     "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "active"
    t.string   "link"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["company_id"], name: "index_partner_links_on_company_id"
  end

  create_table "qrcodes", force: :cascade do |t|
    t.integer  "mobject_id"
    t.string   "mobject_type"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["mobject_id"], name: "index_qrcodes_on_mobject_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "set1H"
    t.integer  "set2H"
    t.integer  "set3H"
    t.integer  "set4H"
    t.integer  "set5H"
    t.integer  "set1G"
    t.integer  "set2G"
    t.integer  "set3G"
    t.integer  "set4G"
    t.integer  "set5G"
    t.string   "gameH"
    t.string   "gameG"
    t.string   "breakball"
    t.string   "setball"
    t.string   "matchball"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.string   "search_domain"
    t.string   "controller"
    t.string   "sql_string"
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.string   "keywords"
    t.integer  "mcategory_id"
    t.integer  "distance"
    t.string   "geo_address"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "date_created_at"
    t.string   "mtype"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "status"
    t.string   "lastname"
    t.string   "name"
    t.boolean  "active"
    t.boolean  "anonymous"
    t.boolean  "superuser"
    t.boolean  "webmaster"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.date     "dateofbirth"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "geo_address"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "classificacion"
    t.string   "stripe_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webmasters", force: :cascade do |t|
    t.string   "object_name"
    t.integer  "object_id"
    t.integer  "user_id"
    t.integer  "web_user_id"
    t.text     "user_comment"
    t.text     "web_user_comment"
    t.string   "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_webmasters_on_user_id"
    t.index ["web_user_id"], name: "index_webmasters_on_web_user_id"
  end

end

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

ActiveRecord::Schema.define(version: 20170503181535) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.string   "iban"
    t.boolean  "is_account_ver"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.text     "description"
    t.string   "name"
    t.float    "num"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "appointment_documents", force: :cascade do |t|
    t.integer  "appointment_id"
    t.string   "name"
    t.text     "description"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "appointments", force: :cascade do |t|
    t.string   "status"
    t.boolean  "active"
    t.string   "subject"
    t.integer  "user_id1"
    t.integer  "user_id2"
    t.date     "app_date"
    t.integer  "time_from"
    t.integer  "time_to"
    t.boolean  "confirmed"
    t.string   "channel"
    t.string   "channel_detail"
    t.boolean  "reminder"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "appparams", force: :cascade do |t|
    t.string   "domain"
    t.string   "parent_domain"
    t.string   "right"
    t.boolean  "access"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mobject_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "status"
    t.boolean  "active"
    t.boolean  "social"
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
  end

  create_table "credentials", force: :cascade do |t|
    t.integer  "appparam_id"
    t.integer  "user_id"
    t.boolean  "access"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "partner_id"
    t.string   "customer_number"
    t.boolean  "tickets"
    t.boolean  "newsletter"
    t.integer  "advisor_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["owner_id"], name: "index_customers_on_owner_id"
    t.index ["owner_type"], name: "index_customers_on_owner_type"
  end

  create_table "edition_arcticles", force: :cascade do |t|
    t.integer  "mobject_id"
    t.integer  "edition_id"
    t.string   "status"
    t.boolean  "active"
    t.integer  "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "editions", force: :cascade do |t|
    t.integer  "mobject_id"
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.boolean  "active"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.date     "release_date"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string   "header"
    t.text     "body"
    t.integer  "m_from"
    t.integer  "m_to"
    t.string   "status"
    t.string   "back_url"
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
  end

  create_table "madvisors", force: :cascade do |t|
    t.integer  "mobject_id"
    t.integer  "user_id"
    t.string   "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "role"
  end

  create_table "mcalendars", force: :cascade do |t|
    t.string   "status"
    t.string   "object"
    t.integer  "mobject_id"
    t.boolean  "active"
    t.integer  "user_id"
    t.integer  "company_id"
    t.date     "date_from"
    t.integer  "time_from"
    t.date     "date_to"
    t.integer  "time_to"
    t.boolean  "confirmed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean  "headline"
    t.string   "textoptions"
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
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mlikes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mobject_id"
    t.boolean  "likeit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mobjects", force: :cascade do |t|
    t.string   "mtype"
    t.string   "msubtype"
    t.integer  "mcategory_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "status"
    t.string   "name"
    t.text     "description"
    t.string   "reward"
    t.float    "interest_rate"
    t.date     "due_date"
    t.date     "date_from"
    t.date     "date_to"
    t.integer  "time_from"
    t.integer  "time_to"
    t.integer  "days"
    t.float    "amount"
    t.integer  "price"
    t.text     "tasks"
    t.text     "skills"
    t.text     "offers"
    t.boolean  "social"
    t.boolean  "eventpart"
    t.decimal  "price_reg"
    t.decimal  "price_new"
    t.boolean  "active"
    t.boolean  "online_pub"
    t.string   "keywords"
    t.string   "homepage"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "risk"
    t.string   "quality"
    t.string   "costinfo"
    t.string   "geo_address"
    t.float    "sum_rating"
    t.float    "sum_amount"
    t.float    "sum_paufwand_ist"
    t.float    "sum_pkosten_ist"
    t.float    "sum_paufwand_plan"
    t.float    "sum_pkosten_plan"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "parent"
    t.index ["owner_id"], name: "index_mobjects_on_owner_id"
    t.index ["owner_type"], name: "index_mobjects_on_owner_type"
  end

  create_table "mratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mobject_id"
    t.string   "comment"
    t.integer  "rating"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "msponsors", force: :cascade do |t|
    t.string   "status"
    t.integer  "company_id"
    t.integer  "mobject_id"
    t.boolean  "active"
    t.string   "slevel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mstats", force: :cascade do |t|
    t.string   "status"
    t.integer  "mobject_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.float    "amount"
    t.boolean  "anonymous"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_mstats_on_owner_id"
    t.index ["owner_type"], name: "index_mstats_on_owner_type"
  end

  create_table "participants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mobject_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "plannings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mobject_id"
    t.string   "jahr"
    t.string   "monat"
    t.float    "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "jahrmonat"
    t.string   "costortime"
    t.string   "description"
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
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "mobject_id"
    t.string   "name"
    t.text     "description"
    t.integer  "sequence"
    t.integer  "mcategory_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
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
    t.integer  "ticket_id"
    t.integer  "age_from"
    t.integer  "age_to"
    t.datetime "date_from"
    t.datetime "date_to"
    t.integer  "distance"
    t.string   "geo_address"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "date_created_at"
    t.integer  "rating"
    t.boolean  "social"
    t.boolean  "customer"
    t.integer  "amount_from_target"
    t.integer  "amount_to_target"
    t.integer  "amount_from"
    t.integer  "amount_to"
    t.boolean  "special"
    t.string   "mtype"
    t.string   "msubtype"
    t.integer  "counter"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "signage_cals", force: :cascade do |t|
    t.integer  "signage_loc_id"
    t.integer  "signage_camp_id"
    t.date     "date_from"
    t.date     "date_to"
    t.integer  "time_from"
    t.integer  "time_to"
    t.boolean  "confirmed"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "signage_camps", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "signage_hits", force: :cascade do |t|
    t.integer  "signage_camp_id"
    t.integer  "signage_loc_id"
    t.datetime "datetime_from"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "signage_locs", force: :cascade do |t|
    t.string   "status"
    t.string   "name"
    t.text     "description"
    t.boolean  "privateonly"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "geo_address"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "res_v"
    t.integer  "res_h"
    t.float    "price"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "signages", force: :cascade do |t|
    t.integer  "signage_camp_id"
    t.string   "status"
    t.string   "header"
    t.text     "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.boolean  "active"
    t.integer  "mcategory_id"
    t.string   "name"
    t.text     "description"
    t.integer  "amount"
    t.integer  "contingent"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "timetracks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mobject_id"
    t.string   "activity"
    t.float    "amount"
    t.date     "datum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "jahrmonat"
    t.string   "costortime"
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "ttype"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.integer  "account_ver"
    t.integer  "account_bel"
    t.date     "trx_date"
    t.date     "valuta"
    t.string   "status"
    t.boolean  "active"
    t.text     "text"
    t.string   "ref"
    t.decimal  "amount"
    t.string   "object_name"
    t.integer  "object_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["owner_id"], name: "index_transactions_on_owner_id"
    t.index ["owner_type"], name: "index_transactions_on_owner_type"
  end

  create_table "user_answers", force: :cascade do |t|
    t.integer  "answer_id"
    t.integer  "user_id"
    t.float    "num"
    t.string   "name"
    t.boolean  "checker"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_positions", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "geo_address"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_tickets", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.string   "status"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "status"
    t.string   "password"
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
    t.string   "costinfo"
    t.float    "rate"
    t.string   "org"
    t.binary   "image"
    t.boolean  "calendar"
    t.integer  "time_from"
    t.integer  "time_to"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
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
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
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
  end

end

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

ActiveRecord::Schema.define(:version => 20131023114027) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "login",                  :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "atom_votes", :force => true do |t|
    t.integer  "votes_count"
    t.integer  "number"
    t.integer  "position_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "atom_votes", ["position_id", "number"], :name => "index_atom_votes_on_position_id_and_number", :unique => true
  add_index "atom_votes", ["votes_count"], :name => "index_atom_votes_on_votes_count"

  create_table "claims", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "voting_id"
    t.integer  "phone_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "claims", ["participant_id"], :name => "index_claims_on_participant_id"
  add_index "claims", ["voting_id"], :name => "index_claims_on_voting_id"

  create_table "documents", :force => true do |t|
    t.integer  "users_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "phone_numbers", :force => true do |t|
    t.integer  "voting_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "phones", :force => true do |t|
    t.string   "number"
    t.integer  "participant_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "phones", ["number"], :name => "index_phones_on_number", :unique => true
  add_index "phones", ["participant_id"], :name => "index_phones_on_participant_id"

  create_table "positions", :force => true do |t|
    t.integer  "phone_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                  :default => "", :null => false
    t.string   "encrypted_password",                                     :default => "", :null => false
    t.string   "login",                                                  :default => "", :null => false
    t.string   "type"
    t.string   "firstname"
    t.string   "secondname"
    t.string   "fathersname"
    t.string   "phone"
    t.date     "birthdate"
    t.decimal  "billinfo",               :precision => 15, :scale => 10
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.string   "org_name"
    t.string   "site"
    t.string   "post_address"
    t.string   "jur_address"
    t.string   "rc"
    t.string   "kc"
    t.string   "bik"
    t.string   "inn"
    t.string   "kpp"
    t.string   "ceo"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["phone"], :name => "index_users_on_phone", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votings", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.integer  "organization_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "description"
    t.string   "way_to_complete"
    t.integer  "min_count_users"
    t.datetime "end_date"
    t.string   "prize_file_name"
    t.string   "prize_content_type"
    t.integer  "prize_file_size"
    t.datetime "prize_updated_at"
    t.string   "brand_file_name"
    t.string   "brand_content_type"
    t.integer  "brand_file_size"
    t.datetime "brand_updated_at"
    t.float    "cost"
    t.float    "min_sum"
    t.float    "financial_threshold"
    t.float    "budget"
    t.integer  "status",              :default => 0, :null => false
    t.text     "timer"
    t.integer  "points_limit"
    t.integer  "cost_10_points"
    t.integer  "users_population"
  end

end

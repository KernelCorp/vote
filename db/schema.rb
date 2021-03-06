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

ActiveRecord::Schema.define(:version => 20140722085317) do

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

  create_table "claim_statistics", :force => true do |t|
    t.integer  "claim_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "place"
  end

  add_index "claim_statistics", ["claim_id"], :name => "index_claim_statistics_on_claim_id"

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
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "organization_id"
    t.boolean  "old",                     :default => false
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "other_actions", :force => true do |t|
    t.string   "name"
    t.integer  "voting_id"
    t.integer  "points"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "other_actions", ["voting_id"], :name => "index_actions_on_voting_id"

  create_table "payments", :force => true do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "is_approved", :default => false, :null => false
    t.string   "currency"
    t.boolean  "with_promo"
    t.string   "promo"
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

  create_table "promo_uses", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "promo_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "promo_uses", ["participant_id"], :name => "index_promo_uses_on_participant_id"
  add_index "promo_uses", ["promo_id"], :name => "index_promo_uses_on_promo_id"

  create_table "promos", :force => true do |t|
    t.string   "code"
    t.datetime "date_end"
    t.integer  "amount",     :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :id => false, :force => true do |t|
    t.string   "key"
    t.string   "type"
    t.integer  "int_value"
    t.string   "str_value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "text_value"
  end

  create_table "social_actions", :force => true do |t|
    t.string  "type"
    t.integer "voting_id"
    t.integer "like_points"
    t.integer "repost_points"
  end

  add_index "social_actions", ["voting_id", "type"], :name => "index_social_actions_on_voting_id_and_type", :unique => true

  create_table "social_posts", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "voting_id"
    t.string   "post_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "points"
    t.string   "url"
    t.string   "type"
  end

  add_index "social_posts", ["participant_id"], :name => "index_vk_posts_on_participant_id"
  add_index "social_posts", ["voting_id"], :name => "index_vk_posts_on_voting_id"

  create_table "social_profiles", :force => true do |t|
    t.integer "participant_id"
    t.string  "provider"
    t.string  "uid"
  end

  add_index "social_profiles", ["participant_id"], :name => "index_social_profiles_on_participant_id"

  create_table "social_states", :force => true do |t|
    t.integer  "post_id"
    t.integer  "likes"
    t.integer  "reposts"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "social_states", ["post_id"], :name => "index_social_states_on_post_id"

  create_table "social_voters", :force => true do |t|
    t.string   "url"
    t.boolean  "reposted"
    t.string   "relationship"
    t.boolean  "has_avatar"
    t.boolean  "too_friendly"
    t.boolean  "liked"
    t.integer  "zone"
    t.integer  "post_id"
    t.string   "registed_at"
    t.integer  "gender"
    t.datetime "bdate"
    t.string   "city"
    t.string   "social_id"
  end

  add_index "social_voters", ["liked"], :name => "index_social_voters_on_liked"
  add_index "social_voters", ["post_id", "url"], :name => "index_social_voters_on_post_id_and_url", :unique => true
  add_index "social_voters", ["reposted"], :name => "index_social_voters_on_reposted"

  create_table "states_voters", :id => false, :force => true do |t|
    t.integer "state_id"
    t.integer "voter_id"
  end

  add_index "states_voters", ["state_id", "voter_id"], :name => "index_states_voters_on_state_id_and_voter_id", :unique => true

  create_table "strangers", :force => true do |t|
    t.string   "phone"
    t.string   "email"
    t.string   "firstname"
    t.string   "secondname"
    t.string   "fathersname"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "strategies", :force => true do |t|
    t.integer "voting_id"
    t.float   "red",       :default => 0.1
    t.float   "yellow",    :default => 1.0
    t.float   "green",     :default => 1.0
    t.float   "grey",      :default => 1.0, :null => false
  end

  add_index "strategies", ["voting_id"], :name => "index_strategies_on_voting_id"

  create_table "strategy_criterions", :force => true do |t|
    t.integer "priority",    :default => 0, :null => false
    t.integer "zone"
    t.string  "type"
    t.integer "strategy_id"
    t.string  "group_id"
  end

  add_index "strategy_criterions", ["strategy_id"], :name => "index_strategy_criterions_on_strategy_id"

  create_table "text_pages", :force => true do |t|
    t.string   "name"
    t.text     "source"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "scope"
  end

  add_index "text_pages", ["slug"], :name => "index_text_pages_on_slug", :unique => true

  create_table "unconfirmed_phones", :force => true do |t|
    t.string   "number"
    t.string   "confirmation_code"
    t.integer  "participant_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "unconfirmed_phones", ["participant_id"], :name => "index_unconfirmed_phones_on_participant_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "login",                  :default => "",    :null => false
    t.string   "type"
    t.string   "firstname"
    t.string   "secondname"
    t.string   "fathersname"
    t.string   "phone"
    t.date     "birthdate"
    t.integer  "billinfo",               :default => 0,     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
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
    t.integer  "age"
    t.boolean  "gender"
    t.string   "city"
    t.boolean  "is_confirmed",           :default => false, :null => false
    t.integer  "parent_id"
    t.boolean  "paid",                   :default => false, :null => false
    t.string   "one_time_password"
  end

  add_index "users", ["phone"], :name => "index_users_on_phone", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vote_transactions", :force => true do |t|
    t.integer  "amount"
    t.integer  "claim_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "participant_id"
  end

  create_table "votings", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.integer  "organization_id"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.text     "description"
    t.string   "way_to_complete"
    t.integer  "min_count_users",                :default => 0,                :null => false
    t.datetime "end_date"
    t.string   "prize_file_name"
    t.string   "prize_content_type"
    t.integer  "prize_file_size"
    t.datetime "prize_updated_at"
    t.string   "brand_file_name"
    t.string   "brand_content_type"
    t.integer  "brand_file_size"
    t.datetime "brand_updated_at"
    t.float    "cost",                           :default => 0.0,              :null => false
    t.float    "min_sum",                        :default => 0.0,              :null => false
    t.float    "financial_threshold"
    t.float    "budget",                         :default => 0.0,              :null => false
    t.integer  "status",                         :default => 0,                :null => false
    t.integer  "timer",                          :default => 0,                :null => false
    t.integer  "points_limit",                   :default => 0,                :null => false
    t.float    "cost_10_points",                 :default => 0.0,              :null => false
    t.integer  "users_population",               :default => 0,                :null => false
    t.string   "type",                           :default => "MonetaryVoting", :null => false
    t.string   "custom_head_color"
    t.string   "custom_background_file_name"
    t.string   "custom_background_content_type"
    t.integer  "custom_background_file_size"
    t.datetime "custom_background_updated_at"
    t.integer  "max_users_count"
    t.string   "custom_background_color"
    t.datetime "end_timer"
    t.string   "prize1_file_name"
    t.string   "prize1_content_type"
    t.integer  "prize1_file_size"
    t.datetime "prize1_updated_at"
    t.string   "prize2_file_name"
    t.string   "prize2_content_type"
    t.integer  "prize2_file_size"
    t.datetime "prize2_updated_at"
    t.string   "prize3_file_name"
    t.string   "prize3_content_type"
    t.integer  "prize3_file_size"
    t.datetime "prize3_updated_at"
    t.text     "how_participate"
    t.string   "slug"
    t.integer  "snapshot_frequency",             :default => 2,                :null => false
  end

  add_index "votings", ["slug"], :name => "index_votings_on_slug", :unique => true
  add_index "votings", ["snapshot_frequency"], :name => "index_votings_on_snapshot_frequency"

  create_table "what_dones", :force => true do |t|
    t.integer  "who_id"
    t.integer  "voting_id"
    t.integer  "what_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "what_dones", ["voting_id"], :name => "index_what_dones_on_voting_id"
  add_index "what_dones", ["what_id"], :name => "index_what_dones_on_what_id"
  add_index "what_dones", ["who_id"], :name => "index_what_dones_on_who_id"

end

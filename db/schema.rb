# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100427224956) do

  create_table "activities", :force => true do |t|
    t.integer  "subject_id",   :null => false
    t.string   "subject_type", :null => false
    t.integer  "profile_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "attachment",                       :null => false
    t.string   "description",       :limit => 256
    t.string   "type",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "status_url"
    t.datetime "status_checked_at"
    t.string   "encoded_filename"
  end

  create_table "blog_entries", :force => true do |t|
    t.integer  "project_id", :null => false
    t.integer  "profile_id", :null => false
    t.string   "title",      :null => false
    t.text     "content",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_entries", ["profile_id"], :name => "profile_id"
  add_index "blog_entries", ["project_id"], :name => "project_id"

  create_table "categories", :force => true do |t|
    t.text     "content",     :null => false
    t.text     "description", :null => false
    t.text     "type",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "project_id", :null => false
    t.integer  "profile_id", :null => false
    t.text     "content",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["profile_id"], :name => "profile_id"
  add_index "comments", ["project_id"], :name => "project_id"

  create_table "interests", :force => true do |t|
    t.integer  "profile_id", :null => false
    t.integer  "project_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interests", ["profile_id"], :name => "profile_id"
  add_index "interests", ["project_id"], :name => "project_id"

  create_table "invite_requests", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "name",                                   :null => false
    t.string   "city",                                   :null => false
    t.string   "state"
    t.string   "country",                                :null => false
    t.boolean  "project",             :default => false, :null => false
    t.text     "project_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.integer  "invite_request_id"
    t.string   "token",             :null => false
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legacy_files", :force => true do |t|
    t.integer "owner",         :limit => 8,   :null => false
    t.string  "filename",                     :null => false
    t.string  "enc_filename",                 :null => false
    t.string  "file_type",     :limit => 50,  :null => false
    t.integer "file_size",     :limit => 8,   :null => false
    t.string  "date_uploaded", :limit => 50,  :null => false
    t.string  "caption",       :limit => 600
    t.string  "ext",           :limit => 6,   :null => false
  end

  create_table "legacy_project_files", :id => false, :force => true do |t|
    t.string "project_id", :limit => 99, :null => false
    t.string "file_id",    :limit => 99, :null => false
  end

  create_table "legacy_project_pics", :id => false, :force => true do |t|
    t.string "project_id", :limit => 9, :null => false
    t.string "file_id",    :limit => 9, :null => false
  end

  create_table "legacy_projects", :force => true do |t|
    t.text    "title"
    t.text    "urltitle",                   :null => false
    t.string  "owner",       :limit => 300, :null => false
    t.string  "address",     :limit => 300, :null => false
    t.string  "city",        :limit => 300, :null => false
    t.string  "state",       :limit => 300, :null => false
    t.string  "zip",         :limit => 5,   :null => false
    t.text    "needs"
    t.string  "date",        :limit => 20,  :null => false
    t.boolean "ispublished",                :null => false
    t.string  "status",      :limit => 300, :null => false
    t.text    "description"
    t.text    "haves"
    t.text    "team"
    t.integer "likes"
  end

  create_table "legacy_user_pics", :id => false, :force => true do |t|
    t.string "user_id", :limit => 6, :null => false
    t.string "file_id", :limit => 6, :null => false
  end

  create_table "legacy_users", :force => true do |t|
    t.string  "username",                   :null => false
    t.string  "urlusername",                :null => false
    t.string  "email",                      :null => false
    t.string  "password",                   :null => false
    t.string  "fname",                      :null => false
    t.string  "lname",                      :null => false
    t.string  "address",                    :null => false
    t.string  "city",                       :null => false
    t.string  "state",       :limit => 30,  :null => false
    t.string  "zipcode",     :limit => 15,  :null => false
    t.string  "phone",                      :null => false
    t.text    "services",                   :null => false
    t.string  "website",                    :null => false
    t.string  "last_logon",  :limit => 200, :null => false
    t.boolean "user_type",                  :null => false
    t.boolean "termsagree",                 :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "profile_id", :null => false
    t.integer  "project_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["profile_id"], :name => "profile_id"
  add_index "likes", ["project_id"], :name => "project_id"

  create_table "membership_requests", :force => true do |t|
    t.integer  "project_id", :null => false
    t.integer  "profile_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "profile_id",                    :null => false
    t.integer  "project_id",                    :null => false
    t.boolean  "originator", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["profile_id"], :name => "profile_id"
  add_index "memberships", ["project_id"], :name => "project_id"

  create_table "messages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_id"
    t.integer  "to_id"
    t.string   "subject"
    t.text     "body"
  end

  add_index "messages", ["from_id"], :name => "index_messages_on_from_id"
  add_index "messages", ["to_id"], :name => "index_messages_on_to_id"

  create_table "prints", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_file_size"
    t.string   "image_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile"
  end

  create_table "profile_links", :force => true do |t|
    t.integer  "profile_id", :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                                   :default => true,  :null => false
    t.string   "username",                  :limit => 30,                     :null => false
    t.string   "password_hash",             :limit => 128,                    :null => false
    t.string   "password_salt",             :limit => 40,                     :null => false
    t.string   "first_name",                :limit => 30
    t.string   "last_name",                 :limit => 30
    t.string   "display_name",              :limit => 30
    t.string   "email",                     :limit => 100
    t.string   "url",                       :limit => 100
    t.string   "city",                      :limit => 30
    t.string   "country",                   :limit => 30
    t.string   "state",                     :limit => 30
    t.string   "phone_home",                :limit => 25
    t.string   "phone_mobile",              :limit => 25
    t.string   "phone_office",              :limit => 25
    t.string   "zip",                       :limit => 10
    t.string   "email_verification",        :limit => 40
    t.boolean  "email_verified"
    t.string   "remember_token",            :limit => 100
    t.datetime "remember_token_expires_at"
    t.string   "persistence_token",                                           :null => false
    t.string   "avatar"
    t.string   "perishable_token"
    t.text     "biography"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.text     "education"
    t.text     "employment"
    t.text     "hobbies"
    t.text     "skills"
    t.text     "pastproj"
    t.text     "originalproj"
    t.boolean  "showtutorial",                             :default => true,  :null => false
    t.boolean  "serviceowner",                             :default => false, :null => false
  end

  create_table "projects", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                           :default => true,   :null => false
    t.boolean  "public",                           :default => true
    t.string   "membership_status",                :default => "open", :null => false
    t.string   "title",                                                :null => false
    t.text     "description"
    t.text     "current_resources"
    t.text     "resources_needed"
    t.text     "needs"
    t.string   "url"
    t.string   "slug",                                                 :null => false
    t.string   "avatar"
    t.string   "location"
    t.boolean  "featured",                         :default => false,  :null => false
    t.string   "short_description", :limit => 150,                     :null => false
    t.text     "opdescription"
  end

  create_table "remarks", :force => true do |t|
    t.integer  "blog_entry_id", :null => false
    t.integer  "profile_id",    :null => false
    t.text     "content",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "remarks", ["blog_entry_id"], :name => "remarks_blog_entry_id_fk"
  add_index "remarks", ["profile_id"], :name => "profile_id"

  create_table "replies", :force => true do |t|
    t.integer  "comment_id", :null => false
    t.integer  "profile_id", :null => false
    t.text     "content",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "replies", ["comment_id"], :name => "comment_id"
  add_index "replies", ["profile_id"], :name => "profile_id"

  create_table "service_interests", :force => true do |t|
    t.integer  "profile_id", :null => false
    t.integer  "service_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_interests", ["profile_id"], :name => "profile_id"
  add_index "service_interests", ["service_id"], :name => "service_id"

  create_table "service_membership_requests", :force => true do |t|
    t.integer  "service_id", :null => false
    t.integer  "profile_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_memberships", :force => true do |t|
    t.integer  "profile_id",                    :null => false
    t.integer  "service_id",                    :null => false
    t.boolean  "originator", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_memberships", ["profile_id"], :name => "profile_id"
  add_index "service_memberships", ["service_id"], :name => "service_id"

  create_table "services", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                          :default => true,  :null => false
    t.boolean  "public",                          :default => true
    t.boolean  "featured",                        :default => false
    t.string   "membership_status", :limit => 30
    t.string   "title",                                              :null => false
    t.string   "avatar"
    t.text     "slug"
    t.text     "description"
    t.text     "short_description"
    t.text     "location"
    t.text     "url"
    t.text     "category"
    t.string   "email"
    t.text     "servicelist"
  end

  create_table "sessions", :force => true do |t|
    t.text     "data"
    t.string   "session_id"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "typus_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.string   "original_file_name"
    t.string   "original_file_size"
    t.string   "original_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile"
  end

  add_foreign_key "blog_entries", "profiles", :name => "blog_entries_ibfk_2"
  add_foreign_key "blog_entries", "projects", :name => "blog_entries_ibfk_1"

  add_foreign_key "comments", "profiles", :name => "comments_ibfk_2"
  add_foreign_key "comments", "projects", :name => "comments_ibfk_1"

  add_foreign_key "interests", "profiles", :name => "interests_ibfk_1"
  add_foreign_key "interests", "projects", :name => "interests_ibfk_2"

  add_foreign_key "likes", "profiles", :name => "likes_ibfk_1"
  add_foreign_key "likes", "projects", :name => "likes_ibfk_2"

  add_foreign_key "memberships", "profiles", :name => "memberships_ibfk_1"
  add_foreign_key "memberships", "projects", :name => "memberships_ibfk_2"

  add_foreign_key "messages", "profiles", :name => "messages_from_id_fk", :column => "from_id"
  add_foreign_key "messages", "profiles", :name => "messages_to_id_fk", :column => "to_id"

  add_foreign_key "remarks", "blog_entries", :name => "remarks_blog_entry_id_fk"
  add_foreign_key "remarks", "profiles", :name => "remarks_ibfk_2"

  add_foreign_key "replies", "comments", :name => "replies_ibfk_1"
  add_foreign_key "replies", "profiles", :name => "replies_ibfk_2"

  add_foreign_key "service_interests", "profiles", :name => "service_interests_ibfk_1"
  add_foreign_key "service_interests", "services", :name => "service_interests_ibfk_2"

  add_foreign_key "service_memberships", "profiles", :name => "service_memberships_ibfk_1"
  add_foreign_key "service_memberships", "services", :name => "service_memberships_ibfk_2"

end

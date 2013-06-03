# encoding: UTF-8

ActiveRecord::Schema.define(:version => 20130603094806) do

  create_table "admin_modules", :force => true do |t|
    t.string  "name",                     :null => false
    t.string  "action",                   :null => false
    t.string  "ico_cls"
    t.integer "parent_id", :default => 0, :null => false
  end

  add_index "admin_modules", ["parent_id"], :name => "index_admin_modules_on_parent_id"

  create_table "admin_modules_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "admin_module_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name",      :null => false
    t.string "role_type", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.string "user_id", :null => false
    t.string "role_id", :null => false
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                                                       :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.integer  "active",                          :limit => 1, :default => 1, :null => false
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end

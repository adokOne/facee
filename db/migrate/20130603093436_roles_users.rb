class RolesUsers < ActiveRecord::Migration
  def up
    create_table :roles_users , :id=>false do |t|
      t.string :user_id,    :null => false 
      t.string :role_id,    :null => false
    end
    add_index :roles_users, [:user_id,:role_id], :unique => true
  end

  def down
  	drop_table :roles_users
  end
end

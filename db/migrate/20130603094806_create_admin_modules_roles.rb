class CreateAdminModulesRoles < ActiveRecord::Migration
  def up
	  create_table :admin_modules_roles, :id => false, :force => true do |t|
	    t.integer :role_id
	    t.integer :admin_module_id
	  end
  end

  def down
  end
end

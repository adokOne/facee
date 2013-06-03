class CreateAdminModules < ActiveRecord::Migration
  def up
    create_table :admin_modules do |t|
      t.string :name,    :null => false 
      t.string :action,    :null => false
      t.string :ico_cls,    :default => nil
      t.integer :parent_id,    :null => false , :default=>0
    end
    add_index :admin_modules, :parent_id
  end

  def down
  	drop_table :admin_modules
  end
end

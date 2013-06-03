class CreateRole < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.string :name,         :null => false 
      t.string :role_type,    :null => false
    end
  end

  def down
  	 drop_table :roles
  end
end

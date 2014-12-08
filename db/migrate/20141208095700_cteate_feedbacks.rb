class CteateFeedbacks < ActiveRecord::Migration
  def up
    create_table :feedbacks do |t|
      t.string :email    
      t.string :subject   
      t.text :message    
    end
  end

  def down
  	 drop_table :feedbacks
  end
end

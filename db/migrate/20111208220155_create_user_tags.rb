class CreateUserTags < ActiveRecord::Migration
  def self.up
    create_table :user_tags do |t|
      t.integer :user_id
      t.integer :tag_id
      
      t.timestamps
    end
    add_index :user_tags, :user_id
    add_index :user_tags, :tag_id
    add_index :user_tags, [:user_id, :tag_id], :unique => true
  end
  
  def self.down
    drop_table :user_tags
  end
end

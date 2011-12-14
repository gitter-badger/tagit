class AddUserIdToPostTagsTable < ActiveRecord::Migration
  def self.up
    remove_index :post_tags, [:post_id, :tag_id]
    
    add_column :post_tags, :user_id, :int
    
    add_index :post_tags, :user_id
    add_index :post_tags, [:post_id, :tag_id, :user_id], :unique => true
  end
  
  def self.down
    remove_index :post_tags, :user_id
    remove_index :post_tags, [:post_id, :tag_id, :user_id]
    
    remove_column :post_tags, :user_id
    
    add_index :post_tags, [:post_id, :tag_id], :unique => true
  end
end

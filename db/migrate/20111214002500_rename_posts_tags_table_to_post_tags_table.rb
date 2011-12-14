class RenamePostsTagsTableToPostTagsTable < ActiveRecord::Migration
  def self.up
    remove_index :posts_tags, :post_id
    remove_index :posts_tags, :tag_id
    remove_index :posts_tags, [:post_id, :tag_id]
    
    rename_table :posts_tags, :post_tags
    
    add_index :post_tags, :post_id
    add_index :post_tags, :tag_id
    add_index :post_tags, [:post_id, :tag_id], :unique => true
  end
  
  def self.down
    remove_index :post_tags, :post_id
    remove_index :post_tags, :tag_id
    remove_index :post_tags, [:post_id, :tag_id]
    
    rename_table :post_tags, :posts_tags
    
    add_index :posts_tags, :post_id
    add_index :posts_tags, :tag_id
    add_index :posts_tags, [:post_id, :tag_id], :unique => true
  end
end

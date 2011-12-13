class RenamePostsTagsTable < ActiveRecord::Migration
  def self.up
    rename_table :posts_tags, :post_tags
  end 
  
  def self.down
    rename_table :post_tags, :posts_tags
  end
end

class CreatePostsTagsTable < ActiveRecord::Migration
  def self.up
    create_table :posts_tags, :id => false do |t|
      t.integer :post_id
      t.integer :tag_id
    end
    
    add_index :posts_tags, :post_id
    add_index :posts_tags, :tag_id
    add_index :posts_tags, [:post_id, :tag_id], :unique => true
  end
  
  def self.down
    drop_table :posts_tags
  end
end

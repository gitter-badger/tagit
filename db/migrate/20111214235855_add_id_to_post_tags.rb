class AddIdToPostTags < ActiveRecord::Migration
  def self.up
    add_column :post_tags, :id, :primary_key
  end

  def self.down
    remove_column :post_tags, :id
  end
end

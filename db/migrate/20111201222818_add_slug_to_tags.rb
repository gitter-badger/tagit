class AddSlugToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :slug, :string
    add_index :tags, :slug, :unique => true
  end

  def self.down
    remove_column :tags, :slug
  end
end

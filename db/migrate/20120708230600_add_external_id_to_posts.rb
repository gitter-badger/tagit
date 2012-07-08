class AddExternalIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :external_id, :bigint
    add_column :posts, :external_type, :tinyint
    
    add_index :posts, [:user_id, :external_id, :external_type], :unique => true
  end

  def self.down
    remove_index :posts, [:user_id, :external_id, :external_type]
    
    remove_column :posts, :external_id
    remove_column :posts, :external_type
  end
end

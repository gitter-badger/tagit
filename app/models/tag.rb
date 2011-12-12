class Tag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  attr_accessible :name
  
  has_and_belongs_to_many :posts
  has_many :user_tags, :class_name => "UserTag", :foreign_key => "tag_id", :dependent => :destroy
  
  validates :name,
    :presence => true,
    :length => { :maximum => 30 },
    :uniqueness => { :case_sensitive => false }
    
  def self.called(name) # named
    Tag.where("name = ?", name).first
  end
end

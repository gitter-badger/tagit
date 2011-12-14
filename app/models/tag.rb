class Tag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  attr_accessible :name
  
  has_many :post_tags, :class_name => "PostTag", :foreign_key => "tag_id", :dependent => :destroy
  has_many :user_tags, :class_name => "UserTag", :foreign_key => "tag_id", :dependent => :destroy
  
  validates :name,
    :presence => true,
    :length => { :maximum => 30 },
    :uniqueness => { :case_sensitive => false }
end

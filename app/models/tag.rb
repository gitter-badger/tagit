class Tag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  attr_accessible :name
  
  has_and_belongs_to_many :posts
  has_many :user_tags, :class_name => "UserTag", :foreign_key => "tag_id", :dependent => :destroy
  has_many :following_users, :through => :user_tags, :source => :user
  
  validates :name,
    :presence => true,
    :length => { :maximum => 30 },
    :uniqueness => { :case_sensitive => false }
    
  # called / named
  scope :called, lambda{ |name| where('tags.name = ?', name) }
end

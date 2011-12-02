class Tag < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  attr_accessible :name
  
  has_and_belongs_to_many :posts
  
  validates :name,
    :presence => true,
    :length => { :maximum => 30 },
    :uniqueness => { :case_sensitive => false }
    
  # called / named
  scope :called, lambda { |name| where('tags.name = ?', name) }
end

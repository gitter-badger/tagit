class Tag < ActiveRecord::Base
  attr_accessible :name
  
  has_and_belongs_to_many :posts
  
  validates :name,
    :presence => true,
    :length => { :maximum => 30 },
    :uniqueness => { :case_sensitive => false }
    
  # called e.g. named
  scope :called, lambda { |n| where('tags.name = ?', n) }
end

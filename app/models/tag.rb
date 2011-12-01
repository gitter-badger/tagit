class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  
  validates :name,
    :length => { :maximum => 30 },
    :uniqueness => { :case_sensitive => true }
end

class UserTag < ActiveRecord::Base
  attr_accessible :tag_id
  
  belongs_to :user
  belongs_to :tag
  
  validates :user_id,
    :presence => true
  validates :tag_id,
    :presence => true
end

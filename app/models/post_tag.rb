class PostTag < ActiveRecord::Base
  attr_accessible :post_id, :tag_id
  
  belongs_to :post
  belongs_to :tag
  
  validates :post_id,
    :presence => true
  validates :tag_id,
    :presence => true
end

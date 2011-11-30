class Tag < ActiveRecord::Base
  attr_accessible :name, :parent_tag_id

  belongs_to :user
  belongs_to :tag,
    :foreign_key => "parent_tag_id"
  has_many :tags
end

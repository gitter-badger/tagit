class Post < ActiveRecord::Base
  attr_accessible :title, :content, :tag_list
  
  belongs_to :user
  has_many :post_tags, :class_name => "PostTag", :foreign_key => "post_id", :dependent => :destroy
  has_many :tags, :through => :post_tags, :source => :tag
  
  validates :title,
    :length => { :maximum => 100 }
  
  validates :content,
    :presence => true,
    :length => { :maximum => 1000 }
  validates :user_id,
    :presence => true
  
  default_scope :order => "posts.created_at DESC"
  
  def tag_list
    tags.map{ |tag| tag.name }.join(", ")
  end
  
  def tag_with_list(list, user)
    tag_names = list.split(/,\s*/)
    new_tags = tag_names.map{ |name| Tag.find_by_name(name) or Tag.create(:name => name) }
    post_tags = new_tags.map{ |tag| PostTag.find_by_post_id_and_tag_id_and_user_id(id, tag.id, user.id) or PostTag.create(:post_id => id, :tag_id => tag.id, :user_id => user.id) }
    # TODO: Delete unused tags
  end
  
  def tag!(tag, user)
    post_tags.create!(:tag_id => tag.id, :user_id => user.id)
  end
  
  def untag!(tag, user)
    post_tags.find_by_tag_id_and_user_id(tag, user).destroy
  end
  
  def self.from_followed_users(user)      
    Post.where(:user_id => user.following_ids)
  end
  
  def self.from_user_stream(user) # Select all post from me & users I'm following that have tags I'm following
    Post
      .select('DISTINCT (posts.id), "posts".*')
      .joins('LEFT JOIN "relationships" ON "posts".user_id = "relationships".followed_id')
      .joins('LEFT JOIN "post_tags" ON "posts".id = "post_tags".post_id')
      .joins('LEFT JOIN "user_tags" ON "post_tags".tag_id = "user_tags".tag_id')
      .where('("posts".user_id = ? OR "relationships".follower_id = ?) AND "user_tags".tag_id IS NULL', user.id, user.id)
  end
end

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
  
  default_scope :order => "created_at DESC"
  
  def self.per_page
    10
  end
  
  def tag_list
    post_tags.find_all_by_user_id(user_id).map{ |post_tag| post_tag.tag.name }.join(", ")
  end
  
  def tag_with_list(list, user)
    post_tags.find_all_by_user_id(user.id).each(&:destroy) # Clean up the old tags from this user to make room for the new ones
    
    tag_names = list.split(/,\s*/)
    new_tags = tag_names.map{ |name| Tag.find_by_name(name) or Tag.create(:name => name) }
    post_tags.push(new_tags.map{ |tag| PostTag.find_by_post_id_and_tag_id_and_user_id(id, tag.id, user.id) or PostTag.create(:post_id => id, :tag_id => tag.id, :user_id => user.id) })
  end
  
  def tag!(tag, user)
    post_tags.create!(:tag_id => tag.id, :user_id => user.id)
  end
  
  def untag!(tag, user)
    post_tags.find_by_tag_id_and_user_id(tag, user).destroy
  end
  
  def is_tagged?(tag, user)
    post_tags.find_by_tag_id_and_user_id(tag, user)
  end
  
  def tags_for_user(user) # Select ([post tags] for [user]) + ([post tags] for [followed users] except those the user already has)
    post_tags
      .select('"post_tags".*')
      .joins('JOIN "relationships" ON "post_tags".user_id = "relationships".followed_id')
      .where('"post_tags".user_id = ? OR ("relationships".follower_id = ? AND "post_tags".tag_id NOT IN (SELECT tag_id FROM "post_tags" WHERE post_id = ? AND user_id = ?))', user.id, user.id, id, user.id)
    # user_tag_ids = post_tags.where(:user_id => user.id).map(&:tag_id)
    # post_tags.where("user_id = ? OR (user_id IN (COALESCE(?, 0)) AND tag_id NOT IN (COALESCE(?, 0)))", user.id, user.following, user_tag_ids)
  end
  
  def self.from_followed_users(user)      
    Post.where(:user_id => user.following_ids)
  end
  
  def self.from_user_stream(user) # Select [posts] from [user + followed users] that have [tags the user is following]
    Post
      .select('DISTINCT (posts.id), "posts".*')
      .joins('LEFT JOIN "relationships" ON "posts".user_id = "relationships".followed_id')
      .joins('LEFT JOIN "post_tags" ON "posts".id = "post_tags".post_id')
      .joins('LEFT JOIN "user_tags" ON "post_tags".tag_id = "user_tags".tag_id')
      .where('("posts".user_id = ? OR "relationships".follower_id = ?) AND "user_tags".tag_id IS NULL', user.id, user.id)
  end
end

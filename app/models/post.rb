class Post < ActiveRecord::Base
  attr_accessible :title, :content, :tag_list
  
  belongs_to :user
  has_and_belongs_to_many :tags
  
  validates :title,
    :length => { :maximum => 100 }
  
  validates :content,
    :presence => true,
    :length => { :maximum => 1000 }
  validates :user_id,
    :presence => true
  
  default_scope :order => "posts.created_at DESC"
  
  def tag_list
    self.tags.map{ |tag| tag.name }.join(", ")
  end

  def tag_list=(new_value)
    tag_names = new_value.split(/,\s*/)
    self.tags = tag_names.map{ |name| Tag.called(name) or Tag.create(:name => name) }
  end
  
  def self.from_followed_users(user)      
    Post.where(:user_id => [user.id, user.following_ids])
  end
  
  def self.from_user_stream(user) # Select all post from me & users I'm following that have tags I'm following
    Post
      .select('DISTINCT (posts.id), "posts".*')
      .joins('LEFT JOIN "relationships" ON "posts".user_id = "relationships".followed_id')
      .joins('LEFT JOIN "posts_tags" ON "posts".id = "posts_tags".post_id')
      .joins('LEFT JOIN "user_tags" ON "posts_tags".tag_id = "user_tags".tag_id')
      .where('("posts".user_id = ? OR "relationships".follower_id = ?) AND "user_tags".tag_id IS NULL', user.id, user.id)
  end
end

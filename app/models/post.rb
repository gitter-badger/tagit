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
  
  default_scope :order => 'posts.created_at DESC'
  
  # Return posts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  def tag_list
    self.tags.map { |tag| tag.name }.join(', ')
  end

  def tag_list=(new_value)
    tag_names = new_value.split(/,\s*/)
    self.tags = tag_names.map { |name| Tag.called(name).first or Tag.create(:name => name) }
  end
  
  private
    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
      where("user_id IN (#{following_ids}) OR user_id = :user_id", { :user_id => user })
    end
end

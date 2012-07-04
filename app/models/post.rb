class Post < ActiveRecord::Base
  attr_accessible :title, :content, :tag_list
  
  belongs_to :user
  has_many :post_tags, :class_name => 'PostTag', :foreign_key => 'post_id', :dependent => :destroy
  has_many :tags, :through => :post_tags, :source => :tag
  
  validates :title,
    :length => { :maximum => 100 }
  
  validates :content,
    :presence => true,
    :length => { :maximum => 10000 }
  validates :user_id,
    :presence => true
  
  default_scope :order => 'created_at DESC'
  
  def self.per_page
    10
  end
  
  def tag_list(uid = user_id)
    post_tags.find_all_by_user_id(uid).map{ |post_tag| post_tag.tag.name }.join(', ')
  end
  
  def tag_with_list(list, user, destroy_old = true)
    return if list.blank?
  
    post_tags.find_all_by_user_id(user.id).each(&:destroy) if (destroy_old)
    
    tag_names = list.split(/,\s*/)
    new_tags = tag_names.map{ |tag_name| Tag.find_or_create_by_name(tag_name) }
    post_tags.push(new_tags.map{ |new_tag| PostTag.find_or_create_by_post_id_and_tag_id_and_user_id(id, new_tag.id, user.id) })
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
  
  def tags_for_author
      post_tags
        .select('"tags".name, "post_tags".post_id, "post_tags".tag_id, 0 AS belongs_to_current_user')
        .joins('JOIN "posts" ON "post_tags".post_id = "posts".id')
        .joins('JOIN "tags" ON "post_tags".tag_id = "tags".id')
        .where('"post_tags".user_id = "posts".user_id')
        .order('LOWER("tags".name) ASC')
        .group('"tags".name, "post_tags".post_id, "post_tags".tag_id, belongs_to_current_user')
  end
  
  def tags_for_user(user) # Select ([post tags] for [this user]) + ([post tags] for [author + followed users] except those this user already has)
    post_tags
      .select('"tags".name, "post_tags".post_id, "post_tags".tag_id, (CASE WHEN "post_tags".user_id = ' + user.id.to_s + ' THEN 1 ELSE 0 END) AS belongs_to_current_user')
      .joins('JOIN "posts" ON "post_tags".post_id = "posts".id')
      .joins('JOIN "tags" ON "post_tags".tag_id = "tags".id')
      .joins('LEFT JOIN "relationships" ON "post_tags".user_id = "relationships".followed_id')
      .where('"post_tags".user_id = ? OR (("post_tags".user_id = "posts".user_id OR "relationships".follower_id = ?) AND "post_tags".tag_id NOT IN (SELECT "post_tags".tag_id FROM "post_tags" WHERE "post_tags".post_id = "posts".id AND "post_tags".user_id = ?))', user.id, user.id, user.id)
      .order('LOWER("tags".name) ASC')
      .group('"tags".name, "post_tags".post_id, "post_tags".tag_id, belongs_to_current_user')
  end
  
  def is_collapsed_by(user)
    user.settings.collapse_posts == "true" || (!user.settings.collapsed_posts.nil? && user.settings.collapsed_posts.include?(id))
  end
  
  def self.from_followed_users(user)      
    Post.where(:user_id => user.following_ids)
  end
  
  def self.from_user_stream(user) # Select [posts] from [this user + followed users + tagged posts] that have [tags this user has not blocked]
    Post
      .select('DISTINCT "posts".id, "posts".*')
      .joins('LEFT JOIN "relationships" ON "posts".user_id = "relationships".followed_id')
      .joins('LEFT JOIN "post_tags" ON "posts".id = "post_tags".post_id')
      .joins('LEFT JOIN "user_tags" ON "post_tags".tag_id = "user_tags".tag_id')
      .where('("posts".user_id = ? OR "relationships".follower_id = ? OR "post_tags".user_id = ?) AND "user_tags".tag_id IS NULL', user.id, user.id, user.id)
  end
  
  def self.from_twitter_stream(user)
    return [] if !user.connected_to?("twitter")
    
    client = Twitter::Client.new(
      :consumer_key => ENV["CONSUMER_KEY"],
      :consumer_secret => ENV["CONSUMER_SECRET"],
      :oauth_token => user.twitter_token,
      :oauth_token_secret => user.twitter_secret)
    client.home_timeline.map { |tweet| transform_tweet_to_post(tweet, user.id) }
  end
  
  private
    def self.transform_tweet_to_post(tweet, user_id)
      post = Post.new
      post.id = tweet.id # HACK: Tweet IDs are in the order of 11 digits; TagIt IDs haven't even passed 4 digits yet, but this will have to be rewritten one day
      post.user_id = user_id
      post.title = "#{tweet.user.name} - @#{tweet.user.screen_name}"
      post.content = tweet.text
      post.created_at = tweet.created_at
      return post
    end
    
    # Tweet fields:
    # :created_at => "Wed Jul 04 20:20:06 +0000 2012",
    # :id => 220612973583020034,
    # :id_str => "220612973583020034",
    # :text => "#recipeoftheday always loved Asian flavours, beef with pak choi, mushrooms and noodles\nhttp://t.co/EUaAO8M6",
    # source => "<a href=\"http://www.hootsuite.com\" rel=\"nofollow\">HootSuite</a>",
    # truncated => false,
    # in_reply_to_status_id => nil,
    # in_reply_to_status_id_str => nil,
    # in_reply_to_user_id => nil,
    # in_reply_to_user_id_str => nil,
    # in_reply_to_screen_name => nil,
    # user =>
    # {
    #   :id => 18676177,
    #   id_str => "18676177",
    #   name => "Jamie Oliver",
    #   screen_name => "jamieoliver",
    #   location => "London and Essex",
    #   description => "The Official Jamie Oliver twitter page",
    #   url => "http://www.jamieoliver.com",
    #   protected => false,
    #   followers_count => 2363694,
    #   friends_count => 5096,
    #   listed_count => 29455,
    #   created_at => "Tue Jan 06 14:21:45 +0000 2009",
    #   favourites_count => 29,
    #   utc_offset => 0,
    #   time_zone => "London",
    #   geo_enabled => false,
    #   verified => true,
    #   statuses_count => 8706,
    #   lang => "en",
    #   contributors_enabled => false,
    #   is_translator => false,
    #   profile_background_color => "E5CDB3",
    #   profile_background_image_url => "http://a0.twimg.com/profile_background_images/561167329/IMG_2727.jpg",
    #   profile_background_image_url_https => "https://si0.twimg.com/profile_background_images/561167329/IMG_2727.jpg",
    #   profile_background_tile => true,
    #   profile_image_url => "http://a0.twimg.com/profile_images/1717719456/IMG_5896_normal.JPG",
    #   profile_image_url_https => "https://si0.twimg.com/profile_images/1717719456/IMG_5896_normal.JPG",
    #   profile_link_color => "DF3936",
    #   profile_sidebar_border_color => "00B893",
    #   profile_sidebar_fill_color => "EFEFEF",
    #   profile_text_color => "333333",
    #   profile_use_background_image => true,
    #   show_all_inline_media => true,
    #   default_profile => false,
    #   default_profile_image => false,
    #   following => true,
    #   follow_request_sent => nil,
    #   notifications => nil
    # },
    # geo => nil,
    # coordinates => nil,
    # place => nil,
    # contributors => nil,
    # retweet_count => 65,
    # favorited => false,
    # retweeted => false,
    # possibly_sensitive => false
end

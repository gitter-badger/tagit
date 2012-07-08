class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username
  
  attr_accessor :password
	attr_accessible :name, :username, :email, :password, :password_confirmation, :twitter_token, :twitter_secret
  
  has_settings
  
  has_many :posts, :dependent => :destroy
  
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :reverse_relationships, :class_name => "Relationship", :foreign_key => "followed_id", :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  has_many :post_tags, :class_name => "PostTag", :foreign_key => "user_id", :dependent => :destroy
  
  has_many :user_tags, :class_name => "UserTag", :foreign_key => "user_id", :dependent => :destroy
  has_many :tags, :through => :user_tags, :source => :tag
  
  before_save :encrypt_password
  
  validates :name, :length => { :maximum => 60 }
  validates :username,
    :presence => true,
		:length => { :within => 3..30 },
    :format => { :with => USERNAME_REGEX },
    :uniqueness => { :case_sensitive => false }
  validates :email,
		:presence	=> true,
    :length => { :maximum => 254 },
		:format => { :with => EMAIL_REGEX },
		:uniqueness => { :case_sensitive => false }
  validates :password,
    :presence => true,
    :confirmation => true,
    :length => { :within => 6..40 }
  validates :twitter_token, :uniqueness => true, :allow_nil => true
  
  def self.per_page
    10
  end
  
  def connected_to?(provider)
    case provider
    when "twitter"
      return twitter_token.present? && twitter_secret.present?
    else
      return false
    end
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end
  
  def self.authenticate_with_salt(id, stored_salt)
    user = find_by_id(id)
    (user && user.salt == stored_salt) ? user : nil
  end
  
  def self.authenticate_with_twitter(token, secret)
    find_by_twitter_token_and_twitter_secret(token, secret)
  end
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  
  def is_following_tag?(tag)
    user_tags.find_by_tag_id(tag).nil?
  end
  
  def follow_tag!(tag)
    user_tags.create!(:tag_id => tag.id)
  end
  
  def unfollow_tag!(tag)
    user_tags.find_by_tag_id(tag).destroy
  end
  
  def posts_from_followed_users
    Post.from_followed_users(self)
  end
  
  def stream
    sync_twitter_stream if connected_to?("twitter")
    Post.from_user_stream(self).order('created_at DESC')
  end
  
  def tags_from_posts
    post_tags.map(&:tag).uniq.sort_by{ |tag| tag.name.downcase }
  end
  
  def tags_from_followed_users
    stream.map{ |post| post.post_tags.where(:user_id => following).map(&:tag) }.flatten.uniq.sort_by{ |tag| tag.name.downcase }
  end
  
  private
    def sync_twitter_stream
      user_external_ids = posts.select('external_type, external_id').where(:external_type => ExternalType::Twitter).map(&:external_id)
      
      client = Twitter::Client.new(
        :consumer_key => ENV["CONSUMER_KEY"],
        :consumer_secret => ENV["CONSUMER_SECRET"],
        :oauth_token => twitter_token,
        :oauth_token_secret => twitter_secret)
      
      client.home_timeline.each do |tweet|
        next if user_external_ids.include?(tweet.id)
        
        post = Post.new
        post.user_id = id
        post.external_id = tweet.id
        post.external_type = ExternalType::Twitter
        post.title = "#{tweet.user.name} - @#{tweet.user.screen_name}"
        post.content = tweet.text
        post.created_at = tweet.created_at
        post.save
      end
      
      #TODO: Delete posts that are not tagged and are from users I'm not following anymore
      #Delete older non-tagged tweets to conserve space
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
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
end

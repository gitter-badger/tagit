class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username
  
  attr_accessor :password
	attr_accessible :name, :username, :email, :password, :password_confirmation
  
  has_many :posts,
    :dependent => :destroy
  has_many :relationships,
    :foreign_key => "follower_id",
    :dependent => :destroy
  has_many :following,
    :through => :relationships,
    :source => :followed
  has_many :reverse_relationships,
    :class_name => "Relationship",
    :foreign_key => "followed_id",
    :dependent => :destroy
  has_many :followers,
    :through => :reverse_relationships,
    :source => :follower
	
  validates :name,
    :length => { :maximum => 60 }
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
  
  before_save :encrypt_password
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end

  def self.authenticate_with_salt(id, stored_salt)
    user = find_by_id(id)
    (user && user.salt == stored_salt) ? user : nil
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
  
  def stream
    Post.from_users_followed_by(self)
  end
  
  private
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
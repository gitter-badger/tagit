require "spec_helper"

describe User do
  it "should create a new instance given valid attributes" do
    Factory(:user)
  end

  describe "name validations" do
    it "should reject names that are too long" do
      long_name = "a" * 61
      long_name_user = Factory.build(:user, :name => long_name)
      long_name_user.should_not be_valid
    end
  end
  
  describe "username validations" do
    it "should require a username" do
      no_username_user = Factory.build(:user, :username => "")
      no_username_user.should_not be_valid
    end
    
    it "should reject usernames that are too short" do
      short_username = "a" * 2
      short_username_user = Factory.build(:user, :username => short_username)
      short_username_user.should_not be_valid
    end
    
    it "should reject usernames that are too long" do
      long_username = "a" * 31
      long_username_user = Factory.build(:user, :username => long_username)
      long_username_user.should_not be_valid
    end
    
    it "should reject wrong username format" do
      usernames = ["foo.bar", "foo@bar", "_foobar", "foobar-"]
      usernames.each do |username|
        invalid_username_user = Factory.build(:user, :username => username)
        invalid_username_user.should_not be_valid
      end
    end
    
    it "should be unique" do
      Factory(:user) # Put a user with given username into the database.
      user_with_duplicate_username = Factory.build(:user, :email => "bar@foo.com") # Put a user with the same username, but different email in the database
      user_with_duplicate_username.should_not be_valid
    end
  end
  
  describe "email validations" do
    it "should require an email address" do
      no_email_user = Factory.build(:user, :email => "")
      no_email_user.should_not be_valid
    end
    
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = Factory.build(:user, :email => address)
        valid_email_user.should be_valid
      end
    end
    
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = Factory.build(:user, :email => address)
        invalid_email_user.should_not be_valid
      end
    end
    
    it "should reject duplicate email addresses" do
      Factory(:user) # Put a user with given email address into the database.
      user_with_duplicate_email = Factory.build(:user, :username => "barfoo") # Put a user with the same email, but different username in the database
      user_with_duplicate_email.should_not be_valid
    end
    
    it "should reject email addresses identical up to case" do
      email = "foo@bar.com"
      Factory(:user, :email => email)
      user_with_duplicate_email = Factory.build(:user, :email => email.upcase)
      user_with_duplicate_email.should_not be_valid
    end
  end
  
  describe "password validations" do
    it "should require a password" do
      user_without_password = Factory.build(:user, :password => "", :password_confirmation => "")
      user_without_password.should_not be_valid
    end

    it "should require a matching password confirmation" do
      user_with_mismatching_passwords = Factory.build(:user, :password_confirmation => "invalid")
      user_with_mismatching_passwords.should_not be_valid
    end

    it "should reject short passwords" do
      short_password = "a" * 5
      user_with_short_password = Factory.build(:user, :password => short_password, :password_confirmation => short_password)
      user_with_short_password.should_not be_valid
    end

    it "should reject long passwords" do
      long_password = "a" * 41
      user_with_long_password = Factory.build(:user, :password => long_password, :password_confirmation => long_password)
      user_with_long_password.should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @email = "foo@bar.com"
      @password = "foobar"
      @user = Factory(:user, :email => @email, :password => @password)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@password).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 
    end
    
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@email, "invalid")
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate(Factory.next(:email), @password)
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@email, @password)
        matching_user.should == @user
      end
    end
  end
  
  describe "admin attribute" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  
  describe "post associations" do
    before(:each) do
      @user = Factory(:user)
      @p1 = Factory(:post, :user => @user, :created_at => 1.day.ago)
      @p2 = Factory(:post, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a posts attribute" do
      @user.should respond_to(:posts)
    end
    
    it "should have the right posts in the right order" do
      @user.posts.should == [@p2, @p1]
    end
    
    it "should destroy associated posts" do
      @user.destroy
      [@p1, @p2].each do |post|
        Post.find_by_id(post.id).should be_nil
      end
    end
    
    describe "stream" do
      it "should have a stream" do
        @user.should respond_to(:stream)
      end

      it "should include the user's posts" do
        @user.stream.should include(@p1)
        @user.stream.should include(@p2)
      end

      it "should not include a different user's posts" do
        mp3 = Factory(:post, :user => Factory(:random_user))
        @user.stream.should_not include(mp3)
      end

      it "should include the user's posts" do
        @user.stream.should include(@p1)
        @user.stream.should include(@p2)
      end

      it "should not include a different user's posts" do
        p3 = Factory(:post, :user => Factory(:random_user))
        @user.stream.should_not include(p3)
      end

      it "should include the posts of followed users" do
        followed = Factory(:random_user)
        p3 = Factory(:post, :user => followed)
        @user.follow!(followed)
        @user.stream.should include(p3)
      end
    end
  end
  
  describe "relationships" do
    before(:each) do
      @user = Factory(:user)
      @followed = Factory(:random_user)
    end

    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end
    
    it "should have a following method" do
      @user.should respond_to(:following)
    end
    
    it "should have a following? method" do
      @user.should respond_to(:following?)
    end

    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end
    
    it "should have an unfollow! method" do
      @followed.should respond_to(:unfollow!)
    end

    it "should unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end
    
    it "should have a reverse_relationships method" do
      @user.should respond_to(:reverse_relationships)
    end

    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
  end
end

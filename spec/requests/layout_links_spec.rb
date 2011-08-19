require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end
  
  it "should have the right links on the layout" do
    visit root_path
    # click_link "Home"
    # response.should have_selector('title', :content => "Home")
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "News"
    response.should have_selector('title', :content => "News")
  end
  
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path, :content => "Sign in")
    end
  end
  
  describe "when signed in" do
    before(:each) do
      @user = Factory(:user)
      integration_sign_in(@user)
    end
    
    it "should have a users link" do
      visit root_path
      response.should have_selector("a", :href => users_path, :content => "Users")
    end
    
    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user), :content => "Profile")
    end
    
    it "should have a settings link" do
      visit root_path
      response.should have_selector("a", :href => edit_user_path(@user), :content => "Settings")
    end
    
    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path, :content => "Sign out")
    end
    
    it "should not have a delete button for other users' posts" do
      other_user = Factory(:user, :email => Factory.next(:email))
      visit user_path(other_user)
      response.should_not have_selector("div.delete")
    end
    
    describe "when not admin" do
      it "should not have a delete button" do
        visit users_path
        response.should_not have_selector("div.delete")
      end
    end
  end
  
  describe "when admin" do
    before(:each) do
      @user = Factory(:user, :email => "admin@example.com", :admin => true)
      integration_sign_in(@user)
    end
  
    it "should have a delete button" do
        @users = [@user]
        5.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      visit users_path
      response.should have_selector("div.delete")
    end
  end
end

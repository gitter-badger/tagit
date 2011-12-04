require "spec_helper"

describe "LayoutLinks" do
  it "should have a home page at '/'" do
    get "/"
    response.should have_selector("title", :content => "Home")
  end
  
  it "should have a tag page at '/tags'" do
    get "/tags"
    response.should have_selector("title", :content => "Tags")
  end
  
  it "should have a signup page at '/signup'" do
    get "/signup"
    response.should have_selector("title", :content => "Sign up")
  end
  
  it "should have an about page at '/about'" do
    get "/about"
    response.should have_selector("title", :content => "About")
  end

  it "should have a contact page at '/contact'" do
    get "/contact"
    response.should have_selector("title", :content => "Contact")
  end
  
  it "should have a news page at '/news'" do
    get "/news"
    response.should have_selector("title", :content => "News")
  end
  
  it "should have a help page at '/help'" do
    get "/help"
    response.should have_selector("title", :content => "Help")
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "Home"
    response.should have_selector("title", :content => "Home")
    click_link "Tags"
    response.should have_selector("title", :content => "Tags")
    click_link "About"
    response.should have_selector("title", :content => "About")
    click_link "Contact"
    response.should have_selector("title", :content => "Contact")
    click_link "News"
    response.should have_selector("title", :content => "News")
    click_link "Help"
    response.should have_selector("title", :content => "Help")
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
    
    pending "should not have an edit button for other users' posts"
    
    it "should not have a delete button for other users' posts" do
      other_user = Factory(:random_user)
      visit user_path(other_user)
      response.should_not have_selector("div.delete")
    end
    
    describe "when not admin" do
      it "should not have a delete button for users" do
        visit users_path
        response.should_not have_selector("div.delete")
      end
    end
  end
  
  describe "when admin" do
    before(:each) do
      @user = Factory(:admin)
      integration_sign_in(@user)
    end
    
    it "should not have a delete button for themselves" do
      @users = [@user]
      visit users_path
      response.should_not have_selector("div.delete_button")
    end
    
    it "should have a delete button for users" do
      @users = [@user]
      5.times do
        @users << Factory(:random_user)
      end
      visit users_path
      response.should have_selector("div.delete_button")
    end
  end
end

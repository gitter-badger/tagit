require "spec_helper"

describe TagsController do
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  pending "implement most test"
end

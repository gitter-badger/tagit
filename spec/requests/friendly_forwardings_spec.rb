require "spec_helper"

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    user = Factory.create(:valid_user)
    integration_edit_forward(user)
    response.should render_template("users/edit")
  end
end

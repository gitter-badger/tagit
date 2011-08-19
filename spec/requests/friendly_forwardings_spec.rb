require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    user = Factory(:user)
    integration_edit_forward(user)
    response.should render_template('users/edit')
  end
end

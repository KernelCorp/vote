require 'spec_helper'

describe LoginController, :type => :controller do
  it 'login with one time password' do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = users(:one_time_pass)
    get :create, { participant: { login: user.phone, password: user.one_time_password } }
    assert_response :success
    User.find(user.id).one_time_password.nil?.should_not be_nil
    assigns(:user).nil?.should_not == true
  end
end

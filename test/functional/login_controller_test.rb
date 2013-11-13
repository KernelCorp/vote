require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  test 'login with one time password' do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = users(:one_time_pass)
    get :create, { participant: { login: user.phone, password: user.one_time_password } }
    assert_response :success
    assert User.find(user.id).one_time_password.nil?
    assert !assigns(:user).nil?
  end
end

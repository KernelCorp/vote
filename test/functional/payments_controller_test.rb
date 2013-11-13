require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test 'create payment for user with parent' do
    user = users(:new)
    parent_old_balance = user.parent.billinfo
    get :create, payment: { user_id: user.id, amount: 100 }
    assert user.parent.billinfo == (parent_old_balance + 10)
    assert user.paid
  end



end

require 'test_helper'

class ActionsControllerTest < ActionController::TestCase

  test 'do thing by stranger' do
    action = actions(:first_action)
    post :do, action_id: action.id, email: 'test@test.test', phone: '1334567893'

    stranger = Stranger.where(email: 'test@test.test').first
    done_thing = WhatDone.where(who_id: stranger.id)
    assert !stranger.nil? && !done_thing.nil?
    assert_response :success
  end

  test 'addition stranger data' do
    action = actions(:first_action)
    post :do, action_id: action.id, email: 'test@test.test'
    post :do, action_id: action.id, email: 'test@test.test', phone: '1334567893'
    assert_response :success
    strangers = Stranger.where(email: 'test@test.test')
    assert strangers.count == 1
    assert_equal strangers.first.phone, '1334567893'
  end

end

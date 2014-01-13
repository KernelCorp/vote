require 'test_helper'

class ActionsControllerTest < ActionController::TestCase

  test 'do thing by stranger' do
    action = actions(:first_action)
    org    = action.other_voting.organization
    post :do, action_id: action.id, email: 'test@test.test', phone: '1334567893', login: org.email,
         password: 'jobspass'
    assert_response :success
    stranger = Stranger.where(email: 'test@test.test').first
    assert !stranger.nil?
    done_thing = WhatDone.where(who_id: stranger.id)
    assert !done_thing.nil?
  end

  test 'addition stranger data' do
    action = actions(:first_action)
    org    = action.other_voting.organization
    post :do, action_id: action.id, email: 'test@test.test'
    post :do, action_id: action.id, email: 'test@test.test', phone: '1334567893', login: org.email,
         password: 'jobspass'
    assert_response :success
    strangers = Stranger.where(email: 'test@test.test')
    assert strangers.count == 1
    assert_equal strangers.first.phone, '1334567893'
  end

  test 'access denied if orgs data is invalid' do
      action = actions(:first_action)
      org    = action.other_voting.organization
      post :do, action_id: action.id, email: 'test@test.test', phone: '1334567893', login: org.email,
           password: 'invalid pass'
      assert_response 401
  end

  test 'access denied without org'  do
    action = actions(:first_action)
    post :do, action_id: action.id, email: 'test@test.test'
    assert_response 401
  end

end

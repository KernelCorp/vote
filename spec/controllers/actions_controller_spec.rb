require 'spec_helper'

describe OtherActionsController do

  it 'do thing by stranger' do
    action = other_actions(:first_action)
    org    = action.other_voting.organization
    post :do, action_id: action.id, email: 'test@test.test', phone: '1334567893', login: org.email,
         password: 'jobspass'
    assert_response :success
    stranger = Stranger.where(email: 'test@test.test').first
    stranger.nil?.should_not == true
    done_thing = WhatDone.where(who_id: stranger.id)
    done_thing.nil?.should_not == true
  end

  it 'addition stranger data' do
    action = other_actions(:first_action)
    org    = action.other_voting.organization
    post :do, action_id: action.id, email: 'test@test.test'
    post :do, action_id: action.id, email: 'test@test.test', phone: '1334567893', login: org.email,
         password: 'jobspass'
    assert_response :success
    strangers = Stranger.where(email: 'test@test.test')
    strangers.count.should == 1
    '1334567893'.should == strangers.first.phone
  end

  it 'access denied if orgs data is invalid' do
      action = first(:first)
      org    = action.other_voting.organization
      post :do, action_id: action.id, email: 'test@test.test', phone: '1334567893', login: org.email,
           password: 'invalid pass'
      assert_response 401
  end

  it 'access denied without org'  do
    action = other_actions(:first)
    post :do, action_id: action.id, email: 'test@test.test'
    assert_response 401
  end

end

require 'test_helper'

class ActionsControllerTest < ActionController::TestCase

  test 'do thing by stranger' do
    action = actions(:first_action)
    post :do, id: action.id, email: 'test@test.test', phone: '1334567893'

    stranger = Stranger.where(email: 'test@test.test').first
    done_thing = WhatDone.where(who_id: stranger.id)
    assert !stranger.nil? && !done_thing.nil?
  end

end

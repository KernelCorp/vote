require 'test_helper'

class ClaimsControllerTest < ActionController::TestCase
  test 'create claim' do
    middlebrow = users(:middlebrow)
    sign_in :participant, middlebrow
    voting = votings(:current)
    request.env['HTTP_REFERER'] = '/'
    post :create, voting_id: voting.id
    assert !Claim.where(participant_id: middlebrow.id, voting_id: voting.id).empty?
  end

  test 'create claim with phone' do
    middlebrow = users(:middlebrow)
    sign_in :participant, middlebrow
    voting = votings(:current)
    request.env['HTTP_REFERER'] = '/'
    post :create, voting_id: voting.id, phone: '1122230000'
    assert !middlebrow.phones.where(number: '1122230000').empty?
    assert !Claim.where(participant_id: middlebrow.id, voting_id: voting.id).empty?
  end
end

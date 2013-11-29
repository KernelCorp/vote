require 'test_helper'

class ClaimsControllerTest < ActionController::TestCase

  setup do
    back_to_1985 # To present I mean
  end

  test 'create claim with phone' do
    middlebrow = users(:middlebrow)
    sign_in :participant, middlebrow
    voting = votings(:current)
    request.env['HTTP_REFERER'] = '/'
    post :create, voting_id: voting.id, claim: { phone: '1122230000' }
    assert !middlebrow.phones.where(number: '1122230000').empty?
    assert !Claim.where(participant_id: middlebrow.id, voting_id: voting.id).empty?
  end

  # Monetary voting specific

  test 'create claim in closed voting before timer' do
    middlebrow = users(:middlebrow)
    sign_in :participant, middlebrow
    voting = votings(:closed_at_2015_01_01)
    time_travel_to '01/01/2015'.to_datetime + 0.5
    request.env['HTTP_REFERER'] = '/'
    post :create, voting_id: voting.id, claim: { phone: '1122230000' }
    assert JSON.parse(response.body)['_alert'] == I18n.t('voting.status.close_for_registration')
    assert middlebrow.phones.where(number: '1122230000').empty?
  end
end

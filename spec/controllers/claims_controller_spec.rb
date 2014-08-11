#encoding: utf-8
require 'spec_helper'

describe ClaimsController, :type => :controller do

  before :each do
    back_to_1985 # To present I mean
  end

  it 'create claim with phone' do
    middlebrow = users(:middlebrow)
    sign_in :participant, middlebrow
    voting = votings(:current)
    request.env['HTTP_REFERER'] = '/'
    post :create, voting_id: voting.id, claim: { phone: '1122230000' }
    middlebrow.phones.where(number: '1122230000').empty?.should_not == true
    Claim.where(participant_id: middlebrow.id, voting_id: voting.id).empty?.should_not == true
  end

  # Monetary voting specific

  it 'create claim in closed voting before timer' do
    middlebrow = users(:middlebrow)
    sign_in :participant, middlebrow
    voting = votings(:closed_at_2015_01_01)
    time_travel_to '01/01/2015'.to_datetime + 0.5
    request.env['HTTP_REFERER'] = '/'
    post :create, voting_id: voting.id, claim: { phone: '1122230000' }
    JSON.parse(response.body)['_alert'].should == I18n.t('voting.status.close_for_registration')
    middlebrow.phones.where(number: '1122230000').empty?.should_not == nil
  end
end

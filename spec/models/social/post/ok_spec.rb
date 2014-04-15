require 'spec_helper'

describe Social::Post::Ok do
  before(:each) do
    RestClient.stub(:get) do |url, params|
      case params[:method]
      when 'discussions.get'
        RestClient::Response.create '{ "discussion": { "like_count": 1, "owner_uid": 1 } }', nil, nil
      when 'discussions.getDiscussionLikes'
        RestClient::Response.create '{ "users": [{ "uid": 2, "url_profile": "url" }] }', nil, nil
      when 'friends.areFriends'
        RestClient::Response.create '[{ "uid1": 1, "uid2": 2, "are_friends": true }]', nil, nil
      end
    end
  end

  it '#post_id_from_url' do
    expect( described_class.post_id_from_url('url/topic/14') ).to eq('GROUP_TOPIC 14')
    expect( described_class.post_id_from_url('url/statuses/14') ).to eq('USER_STATUS 14')
    expect( described_class.post_id_from_url('http://ruby-doc.org/core-2.0.0/Hash.html') ).to be_nil
  end

  describe 'creation' do
    before do
      FactoryGirl.create :ok_action, voting: OtherVoting.first
    end

    let(:valid) { FactoryGirl.build :ok_post, url: 'url/statuses/14', omniauth: { 'token' => 'token', 'refresh_token' => 'token' } }
    let(:wrong) { FactoryGirl.build :ok_post, url: 'http://ruby-doc.org/core-2.0.0/Hash.html' }

    it 'valid' do
      expect( valid ).to be_valid
    end

    it 'wrong' do
      expect( wrong ).not_to be_valid
    end

    it '#snapshot_info' do
      valid.save

      shot = valid.snapshot_info

      expect( shot[:state][:likes] ).to eq(1)
      expect( shot[:state][:reposts] ).to eq(0)
      expect( shot[:voters].size ).to eq(1)

      voter = shot[:voters].first

      expect( voter[:url] ).to eq( 'url' )
      expect( voter[:liked] ).to eq( true )
      expect( voter[:reposted] ).to eq( false )
      expect( voter[:relationship] ).to eq( 'friend' )
      expect( voter[:has_avatar] ).to eq( true )
      expect( voter[:too_friendly] ).to eq( false )
    end
  end
end

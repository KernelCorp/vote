require 'spec_helper'

describe Social::Post::Mm do
  before(:each) do
    RestClient.stub(:get) do |url|
      case url
      when /stream\.getByAuthor/
        RestClient::Response.create '[{ "likes": [{ "uid":"1", "link":"url", "has_pic":false, "friends_count":1001 }] }]', nil, nil
      when /friends\.get/
        RestClient::Response.create '["1"]', nil, nil
      when /mir$/
        RestClient::Response.create '{ "uid": 1 }', nil, nil
      else
        nil
      end
    end
  end

  describe '.post_id_from_url' do
    it 'with valid url' do
      expect( described_class.post_id_from_url('http://my.mail.ru/#history-layer=/community/mir/?multipost_id=741D000000790003') ).to match /.+\/.+/
    end

    it 'with unexisting user' do
      expect( described_class.post_id_from_url('http://my.mail.ru/#history-layer=/community/mir0aasq1x/?multipost_id=741D000000790003') ).to be_nil
    end

    it 'with url to different site' do
      expect( described_class.post_id_from_url('http://ruby-doc.org/core-2.0.0/Hash.html') ).to be_nil
    end
  end

  describe 'creation' do
    let(:valid) { FactoryGirl.build :mm_post, url: 'http://my.mail.ru/#history-layer=/community/mir/?multipost_id=741D000000790003' }
    let(:wrong) { FactoryGirl.build :mm_post, url: 'http://my.mail.ru/#history-layer=/community/mir0aasq1x/?multipost_id=741D000000790003' }

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
      expect( voter[:has_avatar] ).to eq( false )
      expect( voter[:too_friendly] ).to eq( true )
    end
  end
end

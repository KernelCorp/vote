require 'spec_helper'

describe Social::Post::Mm do
  describe '.post_id_from_url' do
    before(:each) do
      allow_any_instance_of(RestClient::Resource).to receive(:get) do |instance|
        if /\/community\/mir$/ =~ instance.url
          RestClient::Response.create '{ "uid": 1 }', nil, nil
        else
          nil
        end
      end
    end

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

    before(:each) do
      allow_any_instance_of(RestClient::Resource).to receive(:get) do |instance|
        case instance.url
        when /\/api\?/
          RestClient::Response.create '[{ "likes": [{ "link":"asd", "has_pic":true, "friends_count":5 }] }]', nil, nil
        when /mir$/
          RestClient::Response.create '{ "uid": 1 }', nil, nil
        else
          nil
        end
      end
    end

    it 'valid' do
      expect( valid ).to be_valid
    end

    it 'wrong' do
      expect( wrong ).not_to be_valid
    end

    it '#snapshot_info' do
      valid.save
      shot = valid.snapshot_info

      expect( shot[:state][:likes] ).to be >= 0
      expect( shot[:state][:reposts] ).to be >= 0

      if shot[:state][:likes] > 0
        expect( shot[:voters].size ).to be > 0
      end
    end
  end
end

require 'spec_helper'

describe Social::Post::Fb do
  before(:each) do
    allow_any_instance_of(Koala::Facebook::API).to receive(:fql_query) do |instance, query|
      case query
      when /"artem.mikhalitsin"/
        [{ 'id' => 11 }] #1116565541 #549395534
      when /"11_10202614677104238"/
        [{ 'post_id' => '11_10202614677104238' }]
      else
        nil
      end
    end

    allow_any_instance_of(Koala::Facebook::API).to receive(:fql_multiquery) do
      {
        'query1' => [{ 'like_info' => { 'like_count' => 1 }, 'share_info' => { 'share_count' => 1 } }],
        'query2' => [{ 'user_id' => '1' }],
        'query3' => [{ 'uid' => '1', 'friend_count' => 1001, 'profile_url' => 'url' }],
        'query4' => [{ 'uid2' => '1' }],
        'query5' => [{ 'id' => '1', 'is_silhouette' => true }]
      }
    end
  end

  describe '.post_id_from_url' do
    it 'with valid url' do
      expect( described_class.post_id_from_url('https://www.facebook.com/artem.mikhalitsin/posts/10202614677104238?stream_ref=1') ).to be_a_kind_of(String)
    end

    it 'with unexisting user' do
      expect( described_class.post_id_from_url('https://www.facebook.com/artem.mikhalitsin0aasq1x/posts/10202614677104238?stream_ref=1') ).to be_nil
    end

    it 'with url to different site' do
      expect( described_class.post_id_from_url('http://ruby-doc.org/core-2.0.0/Hash.html') ).to be_nil
    end
  end

  describe 'creation' do
    before do
      FactoryGirl.create :fb_action, voting: OtherVoting.first
    end

    let(:valid) { FactoryGirl.build :fb_post, url: 'https://www.facebook.com/artem.mikhalitsin/posts/10202614677104238?stream_ref=1' }
    let(:wrong) { FactoryGirl.build :fb_post, url: 'https://www.facebook.com/artem.mikhalitsin0aasq1x/posts/10202614677104238?stream_ref=1' }

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
      expect( shot[:state][:reposts] ).to eq(1)
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

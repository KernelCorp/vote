=begin
require 'spec_helper'

describe Social::Post::Vk do
  describe '.post_id_from_url' do
    it 'with valid url' do
      expect( described_class.post_id_from_url('http://vk.com/feed?w=wall-34580489_20875') ).to eq '-34580489_20875'
    end

    



    it 'with url to different site' do
      expect( described_class.post_id_from_url('http://ruby-doc.org/core-2.0.0/Hash.html') ).to be_nil
    end
  end

  describe 'creation' do
    before do
      FactoryGirl.create :vk_action, voting: OtherVoting.first
    end

    let(:valid) { FactoryGirl.build :vk_post, url: 'http://vk.com/feed?w=wall-35945484_4982' }
    let(:wrong) { FactoryGirl.build :vk_post, url: 'http://vk.com/feed?w=wall-3458048900_0020875' }

    it 'valid' do
      expect( valid ).to be_valid
    end

    it 'wrong' do
      expect( wrong ).not_to be_valid
    end

    it '#snapshot_info' do
      valid.save
      shot = valid.snapshot_info
      voters = shot[:voters]

      expect( shot[:state][:likes] ).to be >= 0
      expect( shot[:state][:reposts] ).to be >= 0

      if shot[:state][:likes] > 0
        expect( voters.size ).to be > 0
      end
    end
  end
end
=end

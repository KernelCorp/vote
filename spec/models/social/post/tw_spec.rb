require 'spec_helper'

describe Social::Post::Tw do
  describe '.post_id_from_url' do
    it 'with valid url' do
      expect( described_class.post_id_from_url('https://twitter.com/alexmak/status/436459004651642881') ).to be_a_kind_of(String)
    end

    



    it 'with url to different site' do
      expect( described_class.post_id_from_url('http://ruby-doc.org/core-2.0.0/Hash.html') ).to be_nil
    end
  end

  describe 'creation' do
    let(:valid) { FactoryGirl.build :tw_post, url: 'https://twitter.com/Politru_project/status/452972975138942977' }
    let(:wrong) { FactoryGirl.build :tw_post, url: 'https://twitter.com/alexmak/status/43645900465164288109090909' }

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

      if shot[:state][:reposts] > 0
        expect( shot[:voters].size ).to be > 0
      end
    end
  end
end

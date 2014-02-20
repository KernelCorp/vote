require 'spec_helper'

describe Social::Post::Fb do
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
    let(:valid) { FactoryGirl.build :fb_post, url: 'https://www.facebook.com/artem.mikhalitsin/posts/10202614677104238?stream_ref=1' }
    let(:wrong) { FactoryGirl.build :fb_post, url: 'https://www.facebook.com/artem.mikhalitsin0aasq1x/posts/10202614677104238?stream_ref=1' }

    it 'valid' do
      expect( valid ).to be_valid
    end

    it 'wrong' do
      expect( wrong ).not_to be_valid
    end

    describe '#likes' do
      before { valid.save }

      it 'return natural number' do
        expect( valid.likes ).to >= 0
      end
    end
  end
end

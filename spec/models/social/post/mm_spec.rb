#require 'spec_helper'
#
#describe Social::Post::Mm do
#  describe '.post_id_from_url' do
#    it 'with valid url' do
#      expect( described_class.post_id_from_url('http://my.mail.ru/#history-layer=/community/mir/?multipost_id=741D000000790003') ).to match /.+\/.+/
#    end
#
#    it 'with unexisting user' do
#      expect( described_class.post_id_from_url('http://my.mail.ru/#history-layer=/community/mir0aasq1x/?multipost_id=741D000000790003') ).to be_nil
#    end
#
#    it 'with url to different site' do
#      expect( described_class.post_id_from_url('http://ruby-doc.org/core-2.0.0/Hash.html') ).to be_nil
#    end
#  end
#
#  describe 'creation' do
#    let(:valid) { FactoryGirl.build :mm_post, url: 'http://my.mail.ru/#history-layer=/community/mir/?multipost_id=741D000000790003' }
#    let(:wrong) { FactoryGirl.build :mm_post, url: 'http://my.mail.ru/#history-layer=/community/mir0aasq1x/?multipost_id=741D000000790003' }
#
#    it 'valid' do
#      expect( valid ).to be_valid
#    end
#
#    it 'wrong' do
#      expect( wrong ).not_to be_valid
#    end
#
#    describe '#likes' do
#      before { valid.save }
#
#      it 'return natural number' do
#        expect( valid.likes ).to >= 0
#      end
#    end
#  end
#end

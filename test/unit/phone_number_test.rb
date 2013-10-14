require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase
  def setup
    @a = (0..9).to_a
    Position.send :define_method, :validate_votes, proc { |vote| begin super(vote) rescue true end }
  end

  test 'PhoneNumber always have 10 associations with Position, even when just created' do
    @p = PhoneNumber.new
    @p.save!
    count = 0
    @p.each_with_index do |po, i|
      if (!po.nil? and po.class == Position)
        count += 1
      end
    end
    assert count == 10
  end

  test 'can not delete one of Position association' do
    @p = phone_numbers(:only_phone)
    @p.save!
    begin
      @p[@a.shuffle.first].destroy
    raise ArgumentError => e
      assert true
      return
    end
    flunk "Ha Ha! Should don't be here!"
  end

  test 'PhoneNumber has ability to get Position association by index' do
    @p = phone_numbers(:only_phone)
    @p.save!
    a = @p[@a.shuffle.first]
    assert (!a.nil? and a.class == Position)
  end

  test 'PhoneNumber can give lead phone number in voting' do
    @p = phone_numbers(:only_phone)
    @p.save!
    assert [6, 6, 6, 6, 6, 6, 6, 6, 6, 6] == @p.lead_phone_number
  end
end

require 'test_helper'

class PhoneNumberTest < ActiveSupport::TestCase
  def setup
    @a = (0..9).to_a
    # Dirty trick
    PhoneNumber.send :define_method, :populate_with_positions, proc { true }
    Position.send :define_method, :fullup_votes, proc { true }
  end

  test 'can not delete one of Position association' do
    @p = phone_numbers(:only_phone)
    @p.save!
    @p[@a.shuffle.first].destroy
    @p.each_with_index do |e, i|
      assert !e.nil? and e.class == Position
    end
    assert @p.positions.length == 10
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

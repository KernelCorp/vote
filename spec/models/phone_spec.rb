require 'spec_helper'

describe Phone do
  it '[]' do
    phone = phones :middlebrow_first
    (0..9).each do |i|
      phone[i].should == phone.number[i].to_i
    end
  end
end

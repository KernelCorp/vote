require 'spec_helper'

describe Promo do

  describe '#actie?' do
    it "return true if promo's date_end greater than now" do
      promo = FactoryGirl.build :promo, date_end: (DateTime.now + 1.day)
      expect(promo.active?).to be(true)
    end

    it "return false if promo's date_end less than now"  do
      promo = FactoryGirl.build :promo, date_end: (DateTime.now - 1.day)
      expect(promo.active?).to be(false)
    end
  end

end

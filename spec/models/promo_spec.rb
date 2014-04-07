require 'spec_helper'

describe Promo do
  it 'active?' do
    promo = promos :one
    expect(promo.active?).to be(false)
    time_travel_to '11/11/2013'.to_datetime + 0.5 do
      expect(promo.active?).to be(true)
    end
  end
end

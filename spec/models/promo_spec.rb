require 'spec_helper'

describe Promo do
  it 'active?' do
    promo = promos :one
    promo.active?.should be_false
    time_travel_to '11/11/2013'.to_datetime + 0.5
    promo.active?.should be_true
  end
end

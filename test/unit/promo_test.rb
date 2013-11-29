require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  test 'active?' do
    promo = promos :one
    assert !promo.active?
    time_travel_to '11/11/2013'.to_datetime + 0.5
    assert promo.active?
  end
end

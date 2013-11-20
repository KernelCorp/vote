require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  test 'get by id' do
    setting = Setting.find 'key'
    assert !setting.nil?
  end

end

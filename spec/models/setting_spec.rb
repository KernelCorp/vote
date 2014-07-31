require 'spec_helper'

describe Setting do
  it 'get by id' do
    setting = Setting.find 'key'
    setting.should_not be_nil
  end
end

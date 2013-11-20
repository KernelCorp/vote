class IntSetting < Setting
  attr_accessible :value

  def value
    read_attribute :int_value
  end

  def value=(value)
    write_attribute :int_value, value
  end
end
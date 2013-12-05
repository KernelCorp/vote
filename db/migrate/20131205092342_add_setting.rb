#encoding: utf-8

class AddSetting < ActiveRecord::Migration
  def migrate (direction)
    super
    IntSetting.create! key: 'Бонус при первой оплате', value: 100
  end
end

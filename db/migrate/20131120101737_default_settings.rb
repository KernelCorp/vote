#encoding: utf-8

class DefaultSettings < ActiveRecord::Migration
  def migrate(direction)
    super
    IntSetting.create! key: 'Курс', value: 1
    IntSetting.create! key: 'Кол-во участников'
    IntSetting.create! key: 'Кол-во организаций'
    IntSetting.create! key: 'Кол-во призов'
  end
end

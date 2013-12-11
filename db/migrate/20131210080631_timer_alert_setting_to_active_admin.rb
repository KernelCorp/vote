#encoding: utf-8

class TimerAlertSettingToActiveAdmin < ActiveRecord::Migration
  def migrate (direction)
    super
    TextSetting.create! key: 'Уведомление о таймере'
  end
end

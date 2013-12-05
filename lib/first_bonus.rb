#encoding: utf-8
module FirstBonus
  def self.value
    Setting.find_by_key('Бонус при первой оплате').value
  end
end

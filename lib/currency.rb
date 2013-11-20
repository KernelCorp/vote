#coding: utf-8
module Currency
  def self.rate
    rate = Setting.find('Курс').value
    rate.nil? ? 1 : rate
  end

  def self.rur_to_vote rur
    rur * rate
  end

  def self.vote_to_rur vote
    vote / rate
  end
end
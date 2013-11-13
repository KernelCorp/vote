#coding: utf-8
require 'net/http'

class SMSMailer
  def self.send_sms(phone, msg)
    uri = URI( 'http://api.infosmska.ru/interfaces/' + 'SendMessages.ashx')
    params = {login: 'PrizeCentr',
              pwd: 'polis666',
              phones: phone,
              message: msg,
              sender: 'TestSMS'
              }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)
    return true if res.is_a?(Net::HTTPSuccess)
    false
  end
end
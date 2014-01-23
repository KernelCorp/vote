#coding: utf-8
require 'net/http'

class SMSMailer

  def self.send_sms(phone, msg)
    uri = URI( "#{SMSMailerConfig.gateway} #{SendMessages.ashx}")
    params = {login: SMSMailerConfig.login,
              pwd: SMSMailerConfig.password,
              phones: phone,
              message: msg,
              sender: SMSMailerConfig.sender
              }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    return true if res.is_a?(Net::HTTPSuccess)
    false
  end
end

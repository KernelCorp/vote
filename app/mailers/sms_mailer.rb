#coding: utf-8
require 'net/http'

class SMSMailer

  def self.send_sms(phone, msg)
    uri = URI( "#{SMSMailerConfig.gateway}SendMessages.ashx")
    params = {login: SMSMailerConfig.login,
              pwd: SMSMailerConfig.password,
              phones: phone,
              message: msg,
              sender: SMSMailerConfig.sender
              }
    uri.query = URI.encode_www_form(params)

    if Rails.env.production?
      Net::HTTP.get_response(uri).is_a? Net::HTTPSuccess
    else
      true
    end
  end
end

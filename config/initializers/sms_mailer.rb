#config for sms gateway
SMSMailerConfig.setup do |config|
  config.gateway = 'http://api.infosmska.ru/interfaces/'
  config.login = 'PrizeCentr'
  config.password = 'yield'
  config.sender = 'TestSMS'
end
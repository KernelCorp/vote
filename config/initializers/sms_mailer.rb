#config for sms gateway
SMSMailerConfig.setup do |config|
  config.gateway = 'http://api.infosmska.ru/interfaces/'
  config.login = 'PrizeCentr'
  config.password = 'polis666'
  config.sender = 'toprize.ru'
end
# encoding: UTF-8
class ParticipantMailer < ActionMailer::Base
  default from: "hello@toprize.ru"

  def invite(email, parent)
    @parent = parent
    mail to: email,
         subject: 'Приглашение'
  end
end

# encoding: UTF-8
class ParticipantMailer < ActionMailer::Base
  default from: 'hello@toprize.ru'

  def invite (email, parent)
    @parent = parent
    mail to: email,
         subject: t('participant.invite.title')
  end

  def invite_to_vote (email, parent, voting)
    @parent = parent
    @voting = voting
    mail to: email,
         subject: t('participant.invite.title')
  end
end

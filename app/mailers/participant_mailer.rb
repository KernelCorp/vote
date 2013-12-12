# encoding: UTF-8
class ParticipantMailer < ActionMailer::Base
  default from: 'info@toprize.ru'

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

  def timer (voting, participant)
    return nil if participant.email.nil?

    @voting = voting
    @user = participant
    mail to: @user.email, subject: t('participant.mail.timer')
  end
end

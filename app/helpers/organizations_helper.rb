#coding: utf-8
module OrganizationsHelper
  def participants_count
    count = Setting.find('Кол-во участников').value
    count = Participant.count if count.nil?
    count
  end

  def org_count
    count = Setting.find('Кол-во организаций').value
    count = Organization.count if count.nil?
    count
  end

  def voting_count
    count = Setting.find('Кол-во призов').value
    count = Voting.count if count.nil?
    count
  end

end

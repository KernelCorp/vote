module ParticipantHelper

  def ul_lead_phone
    leader = @what.voting.phone.lead_phone_number
    leader.map! do |e| "<li>#{e}</li>" end
    ul = '<ul class="phone yellow">'
    star = '<li>&#9733;</li>'
    ul.concat '<li>+</li><li>7</li>'
    ul.concat star
    ul.concat [leader.shift, leader.shift, leader.shift].join
    ul.concat star
    ul.concat [leader.shift, leader.shift, leader.shift].join
    ul.concat star
    ul.concat [leader.shift, leader.shift].join
    ul.concat star
    ul.concat [leader.shift, leader.shift].join
    ul.concat '</ul>'
    ul
  end

  def ul_your_phone
    # What this?
    yours = @what.phone.number
    yours.map! do |e| "<li>#{e}</li>" end
    ul = '<ul class="phone"><li>SHOW-STOPPER!</li></ul>'
    ul
  end
end

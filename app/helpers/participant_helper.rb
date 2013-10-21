module ParticipantHelper

  def ul_lead_phone
    leader = @what.voting.phone.lead_phone_number
    leader.map! do |e| "<li>#{e}</li>" end
    ul = '<ul class="phone">'
    star = '<li class="star">&#9733;</li>'
    ul.concat '<li class="plus">+</li><li>7</li>'
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
    yours = @what.phone.number
    rates = @what.voting.get_rating_for_phone yours
    yours.each_with_index do |e, i|
      yours[i] = "<li class='number' data-rate='#{rates[i]} #{t 'phone.rate'}' data-color='red'>#{e}</li>"
    end
    ul = '<ul class="phone">'
    star = '<li class="star">&#9733;</li>'
    ul.concat '<li class="plus">+</li><li>7</li>'
    ul.concat star
    ul.concat [yours.shift, yours.shift, yours.shift].join
    ul.concat star
    ul.concat [yours.shift, yours.shift, yours.shift].join
    ul.concat star
    ul.concat [yours.shift, yours.shift].join
    ul.concat star
    ul.concat [yours.shift, yours.shift].join
    ul.concat '</ul>'
    ul
  end

  def numberline
    importance = [
      'ten',
      'nine',
      'eight',
      'seven',
      'six',
      'five',
      'four',
      'three',
      'two',
      'one'
    ]
    positions = @what.voting.phone[@on].sorted_up_votes
    positions.each_with_index do |p, i|
      classes = "number blue #{importance[i]}"
      classes.concat " tail" if i < 4
      classes.concat " first" if i == 9
      classes.concat " your" if @target == p.number
      content = "<div class='numeric' #{"data-rate='1 #{t 'phone.rate'}' data-color='green'" if i == 9}>#{p.number}</div><div class='votes' #{"data-rate='#{t 'number_info.voices'}' data-color='grey'" if i == 9}>#{p.votes_count}</div>"
      if @target == p.number
        content.concat "<div class='delta'>+#{i != 9 ? positions[i + 1].votes_count - p.votes_count : 0}</div>"
      else
        content.concat '<div class="block"></div>'
      end
      positions[i] = "<li class='#{classes}'>#{content}</li>"
    end
    ul = '<ul id="numberline">'
    ul.concat positions.join
    ul.concat '</ul>'
    ul
  end
end

module ApplicationHelper
  def inp( form, field, options = {} )
    return ( form.label field, options[:l_name], options[:l_options] || {} ) +
    options[:between] +
    ( ( form.method( options[:type] || :text_field ) ).call field, options[:i_options] || {} )
  end

  def decide_how_invite
    if match = request.original_url.match(/votings\/(?<voting_id>\d+)/)
      raw "<input type='hidden' name='method' value='invite_to_vote'><input type='hidden' name='voting_id' value='#{match[:voting_id]}'>"
    else
      raw "<input type='hidden' name='method' value='invite'>"
    end
  end

  #def user_signed_in?
  #  organization_signed_in? || participant_signed_in?
  #end
end

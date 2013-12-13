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

  # execute a block with a different format (ex: an html partial while in an ajax request)
  def with_format (format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end
end

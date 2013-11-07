module ApplicationHelper
  def inp( form, field, options = {} )
    return ( form.label field, options[:l_name], options[:l_options] || {} ) +
    options[:between] +
    ( ( form.method( options[:type] || :text_field ) ).call field, options[:i_options] || {} )
  end

  #def user_signed_in?
  #  organization_signed_in? || participant_signed_in?
  #end
end

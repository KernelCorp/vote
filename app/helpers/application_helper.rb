module ApplicationHelper
  def inp( form, field, options = {} )
    return ( form.label field, options[:l_name], options[:l_options] || {} ) + 
    options[:between] + 
    ( ( form.method( options[:type] || :text_field ) ).call field, options[:l_options] || {} )
  end
end

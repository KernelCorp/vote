class ColorInput < Formtastic::Inputs::StringInput
  def to_html
    super <<
    builder.template.javascript_tag( "$('##{ input_html_options[:id] }').spectrum({ preferredFormat: 'hex6', showInitial: true, clickoutFiresChange: true });" )
  end
end
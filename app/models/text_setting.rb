class TextSetting < Setting
  attr_accessible :text_value

  TAGS = %w( ref name end_timer username )

  def parse_text (voting, user)
    voting_path = "http://toprize.ru/votings/#{voting.id}"
    params = {
      'ref' => voting_path,
      'name' => voting.name,
      'end_timer' => I18n.l(voting[:end_timer].localtime, format: :long),
      'username' => user.fullname
    }

    regex = /{(?<type>#{TAGS.join '|'})}/

    text_value.gsub(regex) { params[$~[:type]] }
  end

  def value
    read_attribute :text_value
  end

  def value= (v)
    update_attribute :text_value, v
  end
end

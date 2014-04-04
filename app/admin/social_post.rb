ActiveAdmin.register Social::Post do
  menu false

  show do |post|
    attributes_table do
      row :type do
        t 'social.action.available.' + post.class.name.sub('Social::Post::', '')
      end
      row :id
      row :post_id
      row :url
      row :participant do
        link_to post.participant.fullname, admin_participant_path( post.participant )
      end
      row :created_at
    end

    strategy = post.voting.strategy
    graph_data = { 
      likes:   { green: {}, yellow: {}, red: {}, all: {} }, 
      reposts: { green: {}, yellow: {}, red: {}, all: {} } 
    }
    zones = [ :red, :yellow, :green, :all ]
    post.states.where( created_at: (Time.now.midnight - 3.day)..(Time.now.midnight + 1.day) ).each do |state|
      time = state.created_at.beginning_of_hour

      zones.each do |zone|
        graph_data[:likes][zone][time] = strategy.likes_for_zone zone, state
        graph_data[:reposts][zone][time] = strategy.reposts_for_zone zone, state
      end
    end

    panel t("activerecord.attributes.social/post.likes") do
      line_chart zones.map { |zone| { name: t("activerecord.attributes.social/post.#{zone.to_s}"), data: graph_data[:likes][zone] } }, colors: ['#E85435', '#50E83F', '#FFD951', 'black']
    end

    panel t("activerecord.attributes.social/post.reposts") do
      line_chart zones.map { |zone| { name: t("activerecord.attributes.social/post.#{zone.to_s}"), data: graph_data[:reposts][zone] } }, colors: ['#E85435', '#50E83F', '#FFD951', 'black']
    end
  end

end

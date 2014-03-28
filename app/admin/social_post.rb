ActiveAdmin.register Social::Post do
  menu false

  show do
    attributes_table do
      row :type do |post|
        t 'social.action.available.' + post.class.name.sub('Social::Post::', '')
      end
      row :id
      row :post_id
      row :url
      row :text do |post|
        raw post.text
      end
      row :participant do |post|
        link_to post.participant.fullname, admin_participant_path( post.participant )
      end
      row :created_at
    end

    strategy = post.voting.strategy
    graph_data = { 
      likes:   { green: {}, yellow: {}, red: {} }, 
      reposts: { green: {}, yellow: {}, red: {} } 
    }
    posts.states.where( created_at: (Time.now.midnight - 3.day)..Time.now.midnight ).each do |state|
      time = state.created_at.ago.beginning_of_hour

      Strategy::ZONES.each_key do |zone|
        data[:likes][zone][time] = strategy.likes_for_zone zone, state
        data[:reposts][zone][time] = strategy.reposts_for_zone zone, state
      end
    end

    panel 'Likes Graphic' do
      line_chart Strategy::ZONES.keys.map { |zone| { name: zone.to_s, data: graph_data[:likes][zone] } }
    end

    panel 'Reposts Graphic' do
      line_chart Strategy::ZONES.keys.map { |zone| { name: zone.to_s, data: graph_data[:reposts][zone] } }
    end
  end

end

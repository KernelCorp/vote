ActiveAdmin.register Social::Post::Base do
  menu false

  show do |post|
    attributes_table do
      row :type do
        t 'social/actions.' + post.class.name.sub('Social::Post::', '')
      end
      row :id
      row :post_id
      row :url do
        link_to post.url, post.url, target: '_blank'
      end
      row :participant do
        link_to post.participant.fullname, admin_participant_path( post.participant )
      end
      row :created_at
    end

    if post.states.count > 0

      strategy = post.voting.strategy

      graph_data = {}

      zones = Strategy::ZONES.collect{ |int, zone| zone }.push :all

      scales = [ :hour, :day ]
      infos = [ :likes, :reposts ]

      scales.each do |scale| 
        graph_data[scale] = {}
        
        infos.each do |info|
          graph_data[scale][info] = {}

          zones.each do |zone|
            graph_data[scale][info][zone] = {}
          end
        end
      end

      states = post.states.order 'id DESC'

      hour_states = states.size > 24 ? states.slice(0,24) : states

      hour_states.each do |state|
        hour = state.created_at.beginning_of_hour
        
        zones.each do |zone|
          graph_data[:hour][:likes][zone][hour] = strategy.likes_for_zone zone, state
          graph_data[:hour][:reposts][zone][hour] = strategy.reposts_for_zone zone, state
        end
      end

      states.group_by { |state| state.created_at.beginning_of_day }.each do |day, states|
        state = states.last

        zones.each do |zone|
          graph_data[:day][:likes][zone][day] = strategy.likes_for_zone zone, state
          graph_data[:day][:reposts][zone][day] = strategy.reposts_for_zone zone, state
        end
      end

      colors = ['#50E83F', '#FFD951', '#E85435', 'grey', 'black']

      infos.each do |info|
        panel t("activerecord.attributes.social/post/base.#{info}") do
          select class: 'scale_select' do
            option 'По часам', value: 0
            option 'По дням', value: 1
          end
          scales.each do |scale|
            div class: 'graph', style: ( scale == :day ? 'display: none;' : nil ) do
              line_chart zones.map { |zone| { name: t("activerecord.attributes.social/post/base.#{zone.to_s}"), data: graph_data[scale][info][zone] } },  colors: colors
            end
          end
        end
      end

      panel 'Голоса' do

        div id: 'voter_filters' do
          select 'data-filter' => 'zone' do
            option 'Все', value: -1
            selectable = t 'other_voting.zones'
            selectable.delete 'grey'
            selectable.each do |name, translation|
              option translation, value: name
            end
          end
          select 'data-filter' => 'criterion' do
            option 'Все', value: -1
            t('strategy/criterions').each do |name, translation|
              option translation, value: name
            end
          end
          select 'data-filter' => 'liked' do
            option 'Все', value: -1
            option 'Лайкнувшие', value: 1
            option 'Не лайкнувшие', value: 0
          end
          select 'data-filter' => 'reposted' do
            option 'Все', value: -1
            option 'Репостнувшие', value: 1
            option 'Не репостнувшие', value: 0
          end
          span '', id: 'filtered_rows'
        end

        table_for post.voting.strategy.cached_voters( post.states.last ).sort_by! { |v| v.zone }, class: 'index_table index', id: 'voters_index' do
          column 'Зона' do |voter|
            select class: 'voter_zone_select', 'data-zone' => voter.zone, 'data-url' => admin_social_voter_path(voter, format: :json) do
              Strategy::ZONES.each do |int, name|
                option t("other_voting.zones.#{name}"), value: name
              end
            end
          end
          column 'Критерий' do |voter|
            span t("strategy/criterions.#{ voter.criterion }"), 'data-criterion' => voter.criterion
          end
          column 'Url' do |voter| 
            link_to voter.url, voter.url, target: '_blank'
          end
          column 'Лайк' do |voter|
            voter.liked ? span( '+', 'data-liked' => '1' ) : span( '', 'data-liked' => '0' )
          end
          column 'Репост' do |voter|
            voter.reposted ? span( '+', 'data-reposted' => '1' ) : span( '', 'data-reposted' => '0' )
          end
        end
      end
    end
  end
end

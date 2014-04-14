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

    strategy = post.voting.strategy

    zones = Strategy::ZONES.collect{ |int, zone| zone }.push :all
    graph_data = {  likes: {}, reposts: {} }
    zones.each do |zone| 
      graph_data[:likes][zone] = {}
      graph_data[:reposts][zone] = {}
    end

    post.states.limit(70).order('id DESC').each do |state|
      time = state.created_at.beginning_of_hour
      
      zones.each do |zone|
        graph_data[:likes][zone][time] = strategy.likes_for_zone zone, state
        graph_data[:reposts][zone][time] = strategy.reposts_for_zone zone, state
      end
    end

    colors = ['#50E83F', '#FFD951', '#E85435', 'grey', 'black']
    panel t('activerecord.attributes.social/post/base.likes') do
      line_chart zones.map { |zone| { name: t("activerecord.attributes.social/post/base.#{zone.to_s}"), data: graph_data[:likes][zone] } }, colors: colors
    end
    panel t('activerecord.attributes.social/post/base.reposts') do
      line_chart zones.map { |zone| { name: t("activerecord.attributes.social/post/base.#{zone.to_s}"), data: graph_data[:reposts][zone] } }, colors: colors
    end

    if post.states.count > 0
      panel 'Голоса' do

        div id: 'voter_filters' do
          select 'data-filter' => 'zone' do
            option 'Все', value: -1
            t('other_voting.zones').each do |name, translation|
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
          column '' do |voter|
            link_to 'Подробнее', admin_social_voter_path( voter )
          end
        end
      end
    end
  end
end

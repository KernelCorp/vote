ActiveAdmin.register OtherVoting do
  filter :false

  controller do
    def update
      voting = OtherVoting.find params[:id]

      voting.complete! if voting.active? && [:prizes,
                                             :close].include?(OtherVoting::STATUSES[params[:other_voting][:status].to_i])

      voting.strategy.update_attributes! params[:other_voting][:strategy_attributes]
      super
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, as: :html_editor
      f.input :how_participate, as: :html_editor
      f.input :prize , as: :file
      f.input :brand , as: :file
      f.input :prize1, as: :file
      f.input :prize2, as: :file
      f.input :prize3, as: :file
      f.input :custom_head_color, as: :color
      f.input :custom_background_color, as: :color
      f.input :custom_background, as: :file
      f.input :status,
              as: :select,
              collection: Hash[Voting::STATUSES.map { |k,v| [t("status.#{v}"),v] }]
      f.input :points_limit
      f.input :max_users_count
      f.input :start_date
      f.input :end_date
      f.input :way_to_complete, as: :select, collection: Voting::WAYS.map {|w| [t("ways.#{w}"), w]}
      f.input :snapshot_frequency,
              as: :select,
              collection: Hash[OtherVoting::FREQUENCY.map { |k,v| [t("other_voting.snapshot_frequencies.#{v}"), v] }]
    end

    f.inputs t('activerecord.models.strategy.one'), for: :strategy do |s|
      s.input :red
      s.input :yellow
      s.input :green

      s.has_many :criterions, allow_destroy: true do |criterion|
        criterion.input :type, as: :select,
          collection: Hash[ Strategy::Criterion::AVAILABLE.map { |v| [ t("strategy/criterions.#{v}"), "Strategy::Criterion::#{v}" ] } ]
        criterion.input :zone, as: :select,
          collection: Hash[ Strategy::ZONES.map { |k,v| [t("other_voting.zones.#{v}"), v] } ]
        criterion.input :priority
      end

    end

    f.actions
  end

  index do
    column :id
    column :name
    column :start_date
    column :end_date
    column :status do |v|
      t("status.#{v.status}")
    end
    column :organization do |voting|
      link_to voting.organization.org_name, admin_organization_path(voting.organization)
    end
    column :max_users_count
    column :points_limit
    actions
  end

  show do |voting|
    attributes_table do
      row :name
      row :description do
        raw voting.description
      end
      row :how_participate do
        raw voting.how_participate
      end
      row :brand  do image_tag voting.brand.url :thumb end
      row :prize  do image_tag voting.prize.url  :thumb end
      row :prize1 do image_tag voting.prize1.url :thumb end
      row :prize2 do image_tag voting.prize2.url :thumb end
      row :prize3 do image_tag voting.prize3.url :thumb end
      row :custom_background do 
        image_tag voting.custom_background.url, height: 165 
      end
      row :custom_background_color do 
        content_tag( :div, nil, style: "width: 220px; height: 50px; background: #{voting.custom_background_color};" )
      end
      row :custom_head_color do 
        content_tag( :div, nil, style: "width: 220px; height: 50px; background: #{voting.custom_head_color};" )
      end
      row :start_date
      row :end_date
      row :status do |v|
        t("status.#{v.status}")
      end
      row :organization do |voting|
        link_to voting.organization.org_name, admin_organization_path(voting.organization)
      end
      row :start_date
      row :end_date
      row :points_limit
      row :way_to_complete do |voting|
        t("ways.#{voting.way_to_complete}")
      end
      row :snapshot_frequency do
        frequency = voting.snapshot_frequency || 'none'
        t "other_voting.snapshot_frequencies.#{frequency}"
      end
    end

    panel 'Участвующие соц. сети' do
      table_for voting.social_actions do
        column 'Название' do |action| 
          t "social/actions.#{ action.type.scan(/\w+$/).first }"
        end
        column 'Цена лайка', :like_points
        column 'Цена репоста', :repost_points
      end
    end

    panel t('activerecord.models.strategy.one') do
      strategy = voting.strategy

      table_for [strategy] do
        column t('activerecord.attributes.strategy.red'), :red
        column t('activerecord.attributes.strategy.yellow'), :yellow
        column t('activerecord.attributes.strategy.green'), :green
      end

      table_for strategy.criterions.sort_by { |x| -x.priority } do
        column t('activerecord.attributes.strategy/criterion.type') do |criterion|
          t "strategy/criterions.#{ criterion.type.scan(/\w+$/).first }"
        end
        column t('activerecord.attributes.strategy/criterion.priority'), :priority
        column t('activerecord.attributes.strategy/criterion.zone') do |criterion|
          t "other_voting.zones.#{ criterion.zone }"
        end
      end

    end

    panel t('activerecord.models.stranger.other') do
      table_for Stranger.joins(:done_things).where(what_dones: { voting_id: voting.id }).uniq do
        column t('activerecord.attributes.stranger.fullname'), :fullname
        column t('activerecord.attributes.stranger.email'), :email
        column t('activerecord.attributes.stranger.phone'), :phone
        column t('activerecord.attributes.stranger.points'), :points
      end
    end

    panel t('activerecord.models.social/post.other') do
      posts = voting.social_posts
      posts.each do |post|
        post[:current_points] = post.count_points
      end
      table_for posts.sort_by! { |x| -x[:current_points] } do
        column t('activerecord.attributes.social/post.post_id'), :post_id do |post|
          link_to post.url, admin_social_post_path( post )
        end
        column t('activerecord.attributes.social/post.participant'), :participant do |post|
          link_to post.participant.fullname, admin_participant_path( post.participant )
        end
        column t('activerecord.attributes.social/post.all') do |post|
          post[:current_points].round
        end
      end
    end
  end
end

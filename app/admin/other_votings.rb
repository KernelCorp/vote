ActiveAdmin.register OtherVoting do
  filter :false

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
              collection: Hash[Voting::STATUSES.map { |k,v| [k, t("status.#{v}")]}].invert
      f.input :points_limit
      f.input :max_users_count
      f.input :cost_of_like
      f.input :cost_of_repost
      f.input :start_date
      f.input :end_date
      f.input :way_to_complete, as: :select, collection: Voting::WAYS.map {|w| [t("ways.#{w}"), w]}
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
    column :cost_of_like
    column :cost_of_repost
    actions
  end

  show do |voting|
    attributes_table do
      row :name
      row :description
      row :how_participate
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
      row :cost_of_like
      row :cost_of_repost
      row :points_limit
      row :way_to_complete do |voting|
        t("ways.#{voting.way_to_complete}")
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

    panel t('activerecord.models.vk_post.other') do
      table_for VkPost.where(voting_id: voting.id ).uniq do
        column t('activerecord.attributes.vk_post.post_id'), :post_id do |vk_post|
          link_to vk_post.post_id, admin_vk_post_path(vk_post)
        end
        column t('activerecord.attributes.vk_post.participant'), :participant do |vk_post|
          link_to vk_post.participant.fullname, admin_participant_path(vk_post.participant)
        end

      end
    end
  end
end

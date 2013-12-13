ActiveAdmin.register MonetaryVoting do
  filter :false

  form do |f|
    f.inputs do
      f.input :name
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
      f.input :cost
      f.input :timer
      f.input :start_date
      f.input :end_date
      f.input :max_users_count, min: 1
      f.input :budget, min: 1
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
    column :budget
    column :way_to_complete
    actions
  end

  show do |voting|
    attributes_table do
      row :name
      row :brand  do image_tag voting.brand.url :thumb end
      row :prize  do image_tag voting.prize.url  :thumb end
      row :prize1 do image_tag voting.prize1.url :thumb end
      row :prize2 do image_tag voting.prize2.url :thumb end
      row :prize3 do image_tag voting.prize3.url :thumb end
      row :custom_head_color do
        content_tag( :div, nil, style: "width: 220px; height: 50px; background: #{voting.custom_head_color};" )
      end
      row :custom_background_color do
        content_tag( :div, nil, style: "width: 220px; height: 50px; background: #{voting.custom_background_color};" )
      end
      row :custom_background do
        image_tag voting.custom_background.url, height: 165
      end
      row :start_date
      row :end_date
      row :cost
      row :timer
      row :countdown do |v|
        raw [
          content_tag(:div, I18n.t('active_admin.start_timer'), id: 'timer', data: { time: v.countdown }),
          javascript_tag('new Timer($("#timer"))')
        ].join('')
      end
      row :status do |v|
        t("status.#{v.status}")
      end
      row :organization do |voting|
        link_to voting.organization.org_name, admin_organization_path(voting.organization)
      end
      row :max_users_count
      row :budget
      row :way_to_complete do |voting|
        t("ways.#{voting.way_to_complete}")
      end
    end
  end
end

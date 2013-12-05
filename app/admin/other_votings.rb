ActiveAdmin.register OtherVoting do
  filter :false

  form do |f|
    f.inputs do
      f.input :name
      f.input :prize , :as => :file
      f.input :brand , :as => :file
      f.input :prize1, :as => :file
      f.input :prize2, :as => :file
      f.input :prize3, :as => :file
      f.input :custom_background , :as => :file
      f.input :status,
              as: :select,
              collection: Hash[Voting::STATUSES.map { |k,v| [k, t("status.#{v}")]}].invert
      f.input :points_limit
      f.input :cost_10_points
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
    column :cost_10_points
    column :points_limit
    actions
  end

  show do |voting|
    attributes_table do
      row :name
      row :prize  do image_tag voting.prize.url  :thumb end
      row :prize1 do image_tag voting.prize1.url :thumb end
      row :prize2 do image_tag voting.prize2.url :thumb end
      row :prize3 do image_tag voting.prize3.url :thumb end
      row :brand  do
        image_tag voting.brand.url :thumb
      end
      row :start_date
      row :end_date
      row :status do |v|
              t("status.#{v.status}")
      end
      row :organization do |voting|
        link_to voting.organization.org_name, admin_organization_path(voting.organization)
      end
      row :cost_10_points
      row :points_limit
    end
  end
end

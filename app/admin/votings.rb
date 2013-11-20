ActiveAdmin.register Voting do
  filter :false
  form do |f|
    f.inputs do
      f.input :name
      f.input :prize , :as => :file
      f.input :brand , :as => :file
      f.input :custom_background , :as => :file
      f.input :status, as: :select, collection: Voting::STATUSES.invert
      f.input :min_count_users
      f.input :way_to_complete
    end
    f.actions
  end

  index do
    column :id
    column :name
    column :start_date
    column :end_date
    column :status
    column :organization do |voting|
      link_to voting.organization.org_name, admin_organization_path(voting.organization)
    end
    column :min_count_users
    column :way_to_complete
    actions
  end

  show do |voting|
    attributes_table do
      row :name
      row :prize do
        image_tag voting.prize.url :thumb
      end
      row :brand do
        image_tag voting.brand.url :thumb
      end
      row :start_date
      row :end_date
      row :status
      row :organization do |voting|
        link_to voting.organization.org_name, admin_organization_path(voting.organization)
      end
      row :min_count_users
      row :way_to_complete
    end
  end

end

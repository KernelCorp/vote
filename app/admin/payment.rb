ActiveAdmin.register Payment do
  filter :false
  index do
    selectable_column
    column :id
    column :amount
    column :user do |p|
     link_to p.user.fullname, admin_participant_path(p.user)
    end
    actions
  end


  show do |payment|
    attributes_table_for payment do
      row :id
      row :amount
      row :user do |p|
        link_to p.user.fullname, admin_participant_path(p.user)
      end
      row :currency
      row :created_at
      row :updated_at
    end
  end

end

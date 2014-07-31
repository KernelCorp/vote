ActiveAdmin.register Participant do
  filter :false
  form do |f|
    f.inputs do
      f.input :firstname
      f.input :secondname
      f.input :fathersname
      f.input :phone
      f.input :email
      f.input :billinfo
      f.input :avatar, :as => :file
    end
    f.actions
  end

  index do
    column :firstname
    column :secondname
    column :fathersname
    column :created_at
    column :phone
    column :email
    column :billinfo
    actions
  end

  show do |p|
    attributes_table do
      row :firstname
      row :secondname
      row :fathersname
      row :created_at
      row :phone
      row :email
      row :billinfo
      row :phones do |p|
        p.phones.map { |phone| phone.number }.join('<br />').html_safe
      end
      row :avatar do
        image_tag p.avatar.url :thumb
      end
    end
  end
  
end

ActiveAdmin.register Participant do

  form do |f|
    f.inputs do
      f.input :firstname
      f.input :secondname
      f.input :fathersname
      f.input :password
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
      row :phone
      row :email
      row :billinfo
      row :avatar do
        image_tag p.avatar.url :thumb
      end
    end
  end
  
end

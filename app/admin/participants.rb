ActiveAdmin.register Participant do

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

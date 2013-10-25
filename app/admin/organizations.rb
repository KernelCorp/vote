ActiveAdmin.register Organization do

  index do
    column :org_name
    column :site
    column :ceo
    actions
  end

  show do |org|

    panel  t('contact_person') do
      attributes_table_for org do
        row :firstname
        row :secondname
        row :fathersname
        row :phone
        row :email
      end
    end

    panel  t('org_data') do
      attributes_table_for org do
        row :avatar do
          image_tag org.avatar.url :thumb
        end
        row :org_name
        row :site
        row :ceo
        row :post_address
        row :jur_address
        row :rc
        row :kc
        row :bik
        row :inn
        row :kpp
      end
    end

    #attributes_table t(:documents) do
    #  org.documents.each do |doc|
    #
    #  end
    #end

  end

  
end

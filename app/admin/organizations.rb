ActiveAdmin.register Organization do
  filter :false
  index do
    column :org_name
    column :site
    column :ceo
    column :is_confirmed do |o|
      t(o.is_confirmed.to_s)
  end
    actions
  end

  form do |f|
    f.inputs do
      f.input :firstname
      f.input :secondname
      f.input :fathersname
      f.input :email
      f.input :org_name
      f.input :site
      f.input :ceo
      f.input :post_address
      f.input :jur_address
      f.input :rc
      f.input :kc
      f.input :bik
      f.input :inn
      f.input :kpp
      f.input :avatar, :as => :file
      f.input :is_confirmed
    end
    f.actions
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
    attributes_table_for org do
      row Organization.human_attribute_name(:documents) do |org|
        org.documents.map { |d| link_to(d.attachment_file_name, d.attachment.url) }.join('<br />').html_safe
      end
    end

    #attributes_table t(:documents) do
    #  org.documents.each do |doc|
    #
    #  end
    #end

  end

  
end

ActiveAdmin.register Setting do
  filter :false

  index do
    column :key
    column :value
    actions
  end

  show do |s|
    attributes_table do
      row :key
      row :value
    end
  end

  form do |f|
    type = 'string'
    type = 'text' if setting.type == 'TextSetting'
    type = 'number' if setting.type == 'IntSetting'
    f.inputs do
      f.input :value, as: type
    end
    f.actions
  end

end

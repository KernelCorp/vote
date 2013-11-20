ActiveAdmin.register Setting do
  filter :false

  index do
    column :key
    column :value
    actions
  end

  show do
    raw :key
    raw :value
  end

  form do |f|
    f.inputs do
      f.input :value
    end
    f.actions
  end

end

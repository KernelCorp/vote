ActiveAdmin.register TextPage do
  filter :false

  index do
    column :name
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :source, as: :html_editor
    end

    f.actions
  end

  show do |voting|
    attributes_table do
      row :name
      row :source
    end
  end
end

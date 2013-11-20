ActiveAdmin.register Setting do
  filter :false

  form do |f|
    f.inputs do
      f.input :value
    end
  end

end

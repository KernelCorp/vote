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
      f.input :scope,
              as: :select,
              collection: Hash[TextPage::SCOPES.map { |key,value| [t("text_page.scope.#{value}"), key]}]
    end

    f.actions
  end

  show do |voting|
    attributes_table do
      row :name
      row :source
      row :scope do
        t("text_page.scope.#{TextPage::SCOPES[voting.scope]}") if voting.scope
      end
    end
  end
end

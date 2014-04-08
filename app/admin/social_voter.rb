ActiveAdmin.register Social::Voter do
  menu false

  show do |voter|
    attributes_table do
      row :url

      row :reposted
      row :liked

      row :relationship
      row :has_avatar
      row :too_friendly
    end
  end
end

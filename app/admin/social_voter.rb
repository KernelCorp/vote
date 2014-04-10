ActiveAdmin.register Social::Voter do
  menu false

  show do |voter|
    attributes_table do
      row :url do
        link_to voter.url, voter.url, target: '_blank'
      end

      row :reposted
      row :liked

      row :relationship
      row :has_avatar
      row :too_friendly
    end
  end
end

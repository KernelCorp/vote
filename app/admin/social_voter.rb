#encoding: utf-8
ActiveAdmin.register Social::Voter do
  menu false

  show do |voter|
    attributes_table do
      row :url do
        link_to voter.url, voter.url, target: '_blank'
      end
      row :registed_at if voter.registed_at

      row :reposted
      row :liked

      row :relationship
      row :has_avatar
      row :too_friendly

      row :zone do
        if voter.zone
          t "other_voting.zones.#{voter.zone}"
        else
          'расчитывается'
        end
      end
    end
  end
end

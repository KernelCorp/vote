ActiveAdmin.register Social::Post do
  menu false

  show do
    attributes_table do
      row :type
      row :id
      row :post_id
      row :url
      #row :text do |post|
      #  raw post.text
      #end
      row :participant do |post|
        link_to post.participant.fullname, admin_participant_path(post.participant)
      end
      row :created_at
    end
  end

end

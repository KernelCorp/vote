ActiveAdmin.register VkPost do
  menu false

  show do
    attributes_table do
      row :id
      row :post_id
      row :text
      row :participant do |post|
        link_to post.participant.fullname, admin_participant_path(post.participant)
      end
      row :created_at
    end
  end

end

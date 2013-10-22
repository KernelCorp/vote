ActiveAdmin.register Voting do

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: Voting::STATUSES
    end
    f.actions
    end
end

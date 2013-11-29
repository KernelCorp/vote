ActiveAdmin.register VoteTransaction do
  filter :claim_voting_name, as: :string
  filter :claim_voting_id, as: :numeric

  index do
    column :id
    column :user do |vt|
      link_to vt.participant.fullname, admin_participant_path(vt.claim.participant)
    end
    column :voting do |vt|
      link_to vt.claim.voting.name, admin_voting_path(vt.claim.voting)
    end
    column :amount
    actions
  end

  show do |vt|
    attributes_table_for vote_transaction do
      row :id
      row :user do |vt|
        link_to vt.participant.fullname, admin_participant_path(vt.claim.participant)
      end
      row :voting do |vt|
        link_to vt.claim.voting.name, admin_voting_path(vt.claim.voting)
      end
      row :amount
      row :created_at
    end
  end
end

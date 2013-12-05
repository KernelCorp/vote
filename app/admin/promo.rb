ActiveAdmin.register Promo do

  show do |p|
    attributes_table do
      row :code
      row :amount
      row :date_end
    end

    panel t('promo.promo_uses') do
      table_for PromoUses.where(promo_id: p.id) do |t|
        t.column t('activerecord.attributes.promo_uses.participant') do |pu|
          link_to pu.participant.fullname, admin_participant_path(pu.participant)
        end
        t.column t('activerecord.attributes.promo_uses.created_at') do |pu|
          l pu.created_at, format: :long
        end
      end
    end
  end

end

class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.references :voting

      t.timestamps
    end
  end
end

class CreateFacebookSetting < ActiveRecord::Migration
  def up
    TextSetting.create! key: 'FacebookAccess'
  end

  def down
  end
end

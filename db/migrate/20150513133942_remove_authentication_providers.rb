class RemoveAuthenticationProviders < ActiveRecord::Migration
  def up
    add_column :user_authentications, :provider, :string
    UserAuthentication.all.each do |ua|
      if ua.authentication_provider_id
        res = execute 'SELECT name FROM authentication_providers WHERE id = ' + ua.authentication_provider_id.to_s
        ua.provider = res[0]['name']
        ua.save!
      else
        ua.destroy!
      end
    end
    change_column :user_authentications, :provider, :string, null: false # add NOT NULL here
    remove_column :user_authentications, :authentication_provider_id
    drop_table :authentication_providers
  end

  def down
    fail ActiveRecord::IrreversibleMigration
    remove_column :user_authentications, :provider
  end
end

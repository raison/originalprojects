class AddLastLoginToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :current_login_at, :datetime, :null => true
    add_column :profiles, :last_login_at, :datetime, :null => true
  end

  def self.down
    remove_column :profiles, :last_login_at
    remove_column :profiles, :current_login_at
  end
end

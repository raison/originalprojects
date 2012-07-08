class CreateServiceMembershipRequests < ActiveRecord::Migration

  def self.up
    create_table :service_membership_requests do |t|
      t.integer :service_id, :null => false
      t.integer :profile_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :service_membership_requests
  end
end


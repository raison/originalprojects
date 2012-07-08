class CreateMembershipRequests < ActiveRecord::Migration
  def self.up
    create_table :membership_requests do |t|
      t.integer :project_id, :null => false
      t.integer :profile_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :membership_requests
  end
end

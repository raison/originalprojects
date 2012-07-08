class CreateServiceMemberships < ActiveRecord::Migration
  def self.up
    create_table :service_memberships do |t|
      t.references :profile, :null => false, :foreign_key => true
      t.references :service, :null => false, :foreign_key => true
      t.boolean :originator, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :service_memberships
  end
end
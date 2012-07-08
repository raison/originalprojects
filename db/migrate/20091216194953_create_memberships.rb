class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.references :profile, :null => false, :foreign_key => true
      t.references :project, :null => false, :foreign_key => true
      t.boolean :originator, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end

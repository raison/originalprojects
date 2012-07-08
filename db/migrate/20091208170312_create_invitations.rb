class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :email, :null => false, :unique => true
      t.string :token, :null => false, :unique => true
      t.datetime :accepted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end

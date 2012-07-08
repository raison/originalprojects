class RewriteInvitationSystem < ActiveRecord::Migration
  def self.up
    drop_table :invitation_tokens
    drop_table :invitations

    create_table :invite_requests do |t|
      t.string :email, :null => false
      t.string :name, :null => false
      t.string :city, :null => false
      t.string :state, :null => true
      t.string :country, :null => false
      t.boolean :project, :null => false, :default => false
      t.text :project_description, :null => true
      t.timestamps
    end

    create_table :invites do |t|
      t.references :invite_request
      t.string :token, :null => false
      t.datetime :accepted_at, :null => true
      t.timestamps
    end

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end

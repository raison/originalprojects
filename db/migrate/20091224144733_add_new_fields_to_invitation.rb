class AddNewFieldsToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :name,         :string,  :null => false
    add_column :invitations, :city,         :string,  :null => false
    add_column :invitations, :state,        :string,  :null => false
    add_column :invitations, :country,      :string,  :null => false
    add_column :invitations, :project,      :boolean, :null => false, :default => false
    add_column :invitations, :description,  :text
  end

  def self.down
    remove_column :invitations, :name
    remove_column :invitations, :city
    remove_column :invitations, :state
    remove_column :invitations, :country
    remove_column :invitations, :project
    remove_column :invitations, :description
  end
end

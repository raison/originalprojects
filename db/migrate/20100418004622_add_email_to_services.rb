class AddEmailToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :email, :string
  end

  def self.down
    remove_column :services, :email
  end
end

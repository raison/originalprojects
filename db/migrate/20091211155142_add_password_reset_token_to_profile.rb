class AddPasswordResetTokenToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :perishable_token, :string
  end

  def self.down
    remove_column :profiles, :perishable_token
  end
end

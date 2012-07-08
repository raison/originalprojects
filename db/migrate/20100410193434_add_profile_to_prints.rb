class AddProfileToPrints < ActiveRecord::Migration
  def self.up
    add_column :prints, :profile, :string
  end

  def self.down
    remove_column :prints, :profile
  end
end

class AddServicelistToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :servicelist, :text
  end

  def self.down
    remove_column :services, :servicelist
  end
end

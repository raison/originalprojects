class AddBiographyToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :biography, :text
  end

  def self.down
    remove_column :profiles, :biography
  end
end

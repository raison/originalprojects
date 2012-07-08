class AddCategoryToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :category, :text
  end

  def self.down
    remove_column :services, :category
  end
end


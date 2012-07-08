class AddProfileToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :profile, :string
  end

  def self.down
    remove_column :videos, :profile
  end
end

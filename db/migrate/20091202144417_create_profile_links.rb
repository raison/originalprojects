class CreateProfileLinks < ActiveRecord::Migration
  def self.up
    create_table :profile_links do |t|
      t.references :profile, :null => false
      t.string :url, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_links
  end
end

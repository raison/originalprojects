class CreateLikes < ActiveRecord::Migration
  def self.up
    create_table :likes do |t|
      t.references :profile, :null => false, :foreign_key => true
      t.references :project, :null => false, :foreign_key => true
      t.timestamps
    end
  end

  def self.down
    drop_table :likes
  end
end

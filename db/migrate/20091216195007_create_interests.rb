class CreateInterests < ActiveRecord::Migration
  def self.up
    create_table :interests do |t|
      t.references :profile_id, :null => false, :foreign_key => true
      t.references :project, :null => false, :foreign_key => true
      t.timestamps
    end
  end

  def self.down
    drop_table :interests
  end
end

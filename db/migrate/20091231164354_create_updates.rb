class CreateUpdates < ActiveRecord::Migration
  def self.up
    create_table :updates do |t|
      t.references :project,  :null => false, :foreign_key => true
      t.references :profile,  :null => false, :foreign_key => true
      t.string :title,        :null => false
      t.text :content,        :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :updates
  end
end

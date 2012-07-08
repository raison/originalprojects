class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :project, :null => false, :foreign_key => true
      t.references :profile, :null => false, :foreign_key => true
      t.text :content,       :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

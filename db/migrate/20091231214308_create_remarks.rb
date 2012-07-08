class CreateRemarks < ActiveRecord::Migration
  def self.up
    create_table :remarks do |t|
      t.references :update,  :null => false, :foreign_key => true
      t.references :profile, :null => false, :foreign_key => true
      t.text :content,       :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :remarks
  end
end

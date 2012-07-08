class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.references :subject, :polymorphic => true, :null => false
      t.references :profile, :null => true
      t.references :project, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end

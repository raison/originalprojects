class CreateServiceInterests < ActiveRecord::Migration
  def self.up
    create_table :service_interests do |t|
      t.references :profile, :null => false, :foreign_key => true
      t.references :service, :null => false, :foreign_key => true
      t.timestamps
    end
  end

  def self.down
    drop_table :interests
  end
end

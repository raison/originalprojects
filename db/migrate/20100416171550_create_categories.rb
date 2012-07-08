class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.text :content,       :null => false
      t.text :description,   :null => false
      t.text :type,          :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end

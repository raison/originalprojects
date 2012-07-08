class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.references :comment, :null => false, :foreign_key => true
      t.references :profile, :null => false, :foreign_key => true
      t.text :content,       :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end

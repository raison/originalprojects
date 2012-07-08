class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services, :force => true do |t|
      t.timestamps

      len = Project::ATTR_LENGTHS

      t.boolean    :active, :null => false, :default => true
      t.boolean    :public, :default => true
      t.boolean    :featured, :default => false
      t.string     :membership_status, :limit => len[:membership_status]
      t.string     :title, :limit => len[:title], :null => false
      t.string     :avatar
      t.text       :slug
      t.text       :description
      t.text       :short_description
      t.text       :location
      t.text       :url
    end
  end

  def self.down
  drop_table :services
  end
end
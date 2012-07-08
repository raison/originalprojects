class CreateAttachments < ActiveRecord::Migration
  def self.up
    profile_lengths     = Profile::ATTR_LENGTHS 
    attachment_lengths  = Attachment::ATTR_LENGTHS
    
    create_table :attachments, :force => true do |t|
      t.references  :attachable,      :polymorphic => true
      t.string      :attachment,      :limit => profile_lengths[:url], :null => false
      t.string      :description,     :limit => attachment_lengths[ :description ]
      t.string      :type,            :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end

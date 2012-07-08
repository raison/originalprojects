class Attachment < ActiveRecord::Base  
  mount_uploader :attachment, AttachmentUploader

  ATTR_LENGTHS = { :description => 256 }
  
  belongs_to :attachable, :polymorphic => true

  validates_length_of :description, 
    :within => 4...ATTR_LENGTHS[ :description ], :allow_nil => true, :allow_blank => true
  validates_processing_of :attachment

  #/ Override white_list in your subclass to define acceptable file extensions
  def white_list
    %w( doc pdf xls txt )
  end
end

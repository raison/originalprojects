class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  #/ If no attachment exists for an object, this provides a placeholder image. 
  #    Pathnames take the form /images/fallback/attachment_type/version_default.png,
  #    where attachment_type is the name of the model, and version is 
  def default_url
    "/images/default/#{self.categorize}/" + 
      [ version_name, "default.png" ].compact.join('_')
  end

  #/ extension_white_list expects an array of valid file extensions. It defers
  #    to the attachment type.
  def extension_white_list
    self.model.try( :white_list ) || self.model.class.class_eval { 'white_list' }
  end

  #/ store_dir provides the folder name for an attachment type. 
  #   It is either the class of the object the attachment is attached to, 
  #   or its class of the attachment type itself. 
  def store_dir
    self.categorize( self.model.attachable.try( :class ) )
  end
  
  def categorize( klass = nil )
    klass ||= self.model.class
    klass.name.tableize.split(/_/).first.pluralize
  end
end

class Image < Attachment 
  mount_uploader :attachment, ImageUploader
  
  def white_list
    %w( jpg jpeg gif png )
  end
end

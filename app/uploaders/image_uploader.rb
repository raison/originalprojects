class ImageUploader < AttachmentUploader

  def extension_white_list
    %w(jpg jpeg png gif)
  end

  version :thumbnail do
    process :resize_to_fill => [37, 37]
  end

  version :square_60 do
    process :resize_to_fill => [60, 60]
  end

  version :small do
    process :resize_to_fill => [130, 120]
  end

  version :avatar do
    process :resize_to_fill => [174, 146]
  end

  version :feature do
    process :resize_to_fill => [258, 160]
  end

  version :large do
    process :resize_to_fit => [453, 360]
  end
end

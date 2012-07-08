class AvatarUploader < AttachmentUploader
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
    process :resize_to_fit => [174, 348]
  end

  version :feature do
    process :resize_to_fill => [258, 160]
  end

  def default_url
    "/images/default/#{version_name}_op-default-avatar.jpg"
  end

  def extension_white_list
    %w(jpg jpeg png gif)
  end

  def store_dir
    'avatars'
  end
end

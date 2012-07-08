class LegacyUserPic < ActiveRecord::Base
  belongs_to :legacy_user, :foreign_key => :user_id
  belongs_to :legacy_file, :foreign_key => :file_id
end

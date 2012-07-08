class LegacyFile < ActiveRecord::Base
  has_one :legacy_project_pic, :foreign_key => :file_id
  has_one :legacy_project_file, :foreign_key => :file_id
  has_one :legacy_user_pic, :foreign_key => :file_id
end

class LegacyProjectFile < ActiveRecord::Base
  belongs_to :legacy_project, :foreign_key => :project_id
  belongs_to :legacy_file, :foreign_key => :file_id
end

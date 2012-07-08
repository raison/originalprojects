# == Schema Information
# Schema version: 20091013220107
#
# Table name: legacy_projects
#
#  id          :integer(4)    not null, primary key
#  title       :text          
#  urltitle    :text          default(""), not null
#  owner       :string(300)   not null
#  address     :string(300)   not null
#  city        :string(300)   not null
#  state       :string(300)   not null
#  zip         :string(5)     not null
#  needs       :text          
#  date        :string(20)    not null
#  ispublished :boolean(1)    not null
#  status      :string(300)   not null
#  description :text          
#  haves       :text          
#  team        :text          
#  likes       :integer(4)    
#

class LegacyProject < ActiveRecord::Base
  has_one :picture, :foreign_key => :project_id, :class_name => 'LegacyProjectPic'
  has_one :file, :through => :picture, :source => :legacy_file
  has_many :snapshots, :foreign_key => :project_id, :class_name => 'LegacyProjectFile'
  has_many :files, :through => :snapshots, :source => :legacy_file
end

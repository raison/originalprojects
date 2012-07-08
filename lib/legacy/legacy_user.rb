# == Schema Information
# Schema version: 20091013220107
#
# Table name: legacy_users
#
#  id          :integer(4)    not null, primary key
#  username    :string(255)   not null
#  urlusername :string(255)   not null
#  email       :string(255)   not null
#  password    :string(255)   not null
#  fname       :string(255)   not null
#  lname       :string(255)   not null
#  address     :string(255)   not null
#  city        :string(255)   not null
#  state       :string(30)    not null
#  zipcode     :string(15)    not null
#  phone       :string(255)   not null
#  services    :text(21474836 default(""), not null
#  website     :string(255)   not null
#  last_logon  :string(200)   not null
#  user_type   :boolean(1)    not null
#  termsagree  :boolean(1)    not null
#

class LegacyUser < ActiveRecord::Base
  has_one :picture, :foreign_key => :user_id, :class_name => 'LegacyUserPic'
  has_one :file, :through => :picture, :source => :legacy_user_pic
end

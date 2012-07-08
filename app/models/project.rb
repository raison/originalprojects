class Project < ActiveRecord::Base
  #------------------------------------------------------------
  # Constants
  #------------------------------------------------------------

  # Field lengths to be used in migrations, html element lengths & validation
  ATTR_LENGTHS = {
    :membership_status => 30,
    :title             => 255
  }

  MEMBERSHIP_STATUS_OPEN   = 'open'
  MEMBERSHIP_STATUS_INVITE = 'invite'
  MEMBERSHIP_STATUS_CLOSED = 'closed'

  MEMBERSHIP_STATUSES = [
    MEMBERSHIP_STATUS_OPEN,
    MEMBERSHIP_STATUS_INVITE,
    MEMBERSHIP_STATUS_CLOSED ]

  #------------------------------------------------------------
  # ActiveRecord Declarations
  #------------------------------------------------------------
  mount_uploader :avatar, AvatarUploader

  has_many :images, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for(:images, :allow_destroy => true,
    :reject_if => lambda { |attrs| attrs['attachment'].blank? } )

  has_many :memberships, :dependent => :destroy
  has_many :profiles, :through => :memberships
  has_many :originators, :through => :memberships, :source => :profile,
    :conditions => ["originator = ?", true]
  has_many :members, :through => :memberships, :source => :profile,
    :conditions => ["originator = ?", false]

  has_many :interests, :dependent => :destroy
  has_many :followers, :through => :interests, :source => :profile

  has_many :membership_requests, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :blog_entries, :dependent => :destroy
  has_many :activities, :dependent => :destroy

  before_validation_on_create :slugify

  named_scope :active, :conditions => { :active => true }
  named_scope :public, :conditions => { :public => true }
  named_scope :visible, :conditions => { :active => true, :public => true }
  named_scope :by_title, :order => 'projects.title ASC'
  named_scope :featured, { :conditions => { :featured => true } }

  opw_validate_lengths(ATTR_LENGTHS)
  validates_inclusion_of :membership_status, :in => MEMBERSHIP_STATUSES
  validates_presence_of :title, :description, :short_description
  validates_length_of :short_description, :maximum => 150, :allow_nil => true
  validates_presence_of :slug
  validates_uniqueness_of :slug

  acts_as_taggable_on :tags

  define_index do
    indexes title
    indexes description
    indexes short_description
    indexes current_resources
    indexes resources_needed
    indexes needs
    indexes url

    where "public = 1"
  end

  #------------------------------------------------------------
  # Instance Methods
  #------------------------------------------------------------

  def typus_name
    title
  end

  def avatar_url(size = :avatar)
    if avatar.present?
      avatar.url(size)
    elsif images.count > 0
      images.first.attachment.url(size)
    else
      ""
    end
  end

  def add_participant(profile, originator = false)
    self.membership_requests.first(:conditions => { :profile_id => profile.id }).try(:destroy)
    self.memberships.create(
      :profile  => profile,
      :originator => originator )
  end

  def promote_profile_to_originator(profile)
    # TODO: If entry exists for profile, change it.
    self.add_participant(profile, true)
  end

  def slugify
    self.slug ||= self.title.try( :to_slug )
  end

  MEMBERSHIP_STATUSES.each do |status|
    define_method "has_#{status}_membership?" do
      self.membership_status == status
    end
  end

  def to_param
    slug || id
  end

  def previous
    project = Project.public.find(:first, :conditions => ['title < ?', title], :order => 'title DESC')
    project || Project.public.first(:order => 'title DESC')
  end

  def next
    project = Project.public.find(:first, :conditions => ['title > ?', title], :order => 'title ASC')
    project || Project.public.first(:order => 'title ASC')
  end

  def non_member_followers
    @non_member_followers ||= self.followers - self.profiles
  end

  private

  def make_connection( attachment )
    attachment.attachable = self
  end
end

# Project.acts_as_taggable

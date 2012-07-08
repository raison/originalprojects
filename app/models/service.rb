class Service < ActiveRecord::Base
  #------------------------------------------------------------
  # Constants
  #------------------------------------------------------------

  # Field lengths to be used in migrations, html element lengths & validation
  ATTR_LENGTHS = {
    :membership_status => 30,
    :title             => 255
  }

 # MEMBERSHIP_STATUS_OPEN   = 'open'
  MEMBERSHIP_STATUS_INVITE = 'invite'
  MEMBERSHIP_STATUS_CLOSED = 'closed'

  MEMBERSHIP_STATUSES = [
    #MEMBERSHIP_STATUS_OPEN,
    MEMBERSHIP_STATUS_INVITE,
    MEMBERSHIP_STATUS_CLOSED ]

  #------------------------------------------------------------
  # ActiveRecord Declarations
  #------------------------------------------------------------
  mount_uploader :avatar, AvatarUploader

  has_many :images, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for(:images, :allow_destroy => true,
    :reject_if => lambda { |attrs| attrs['attachment'].blank? } )

  has_many :service_memberships, :dependent => :destroy
  has_many :profiles, :through => :service_memberships
  has_many :originators, :through => :service_memberships, :source => :profile,
    :conditions => ["originator = ?", true]
  has_many :service_members, :through => :service_memberships, :source => :profile,
    :conditions => ["originator = ?", false]
    
  has_many :service_interests, :dependent => :destroy
  has_many :followers, :through => :service_interests, :source => :profile

  has_many :service_membership_requests, :dependent => :destroy
  #has_many :comments, :dependent => :destroy
  #has_many :likes, :dependent => :destroy
  #has_many :blog_entries, :dependent => :destroy
  #has_many :activities, :dependent => :destroy

  before_validation_on_create :slugify

  named_scope :active, :conditions => { :active => true }
  named_scope :public, :conditions => { :public => true }
  named_scope :visible, :conditions => { :active => true, :public => true }
  named_scope :by_title, :order => 'services.title ASC'
  named_scope :featured, { :conditions => { :featured => true } }

  opw_validate_lengths(ATTR_LENGTHS)
  validates_inclusion_of :membership_status, :in => MEMBERSHIP_STATUSES
  validates_presence_of :title, :description, :short_description, :location
  validates_length_of :short_description, :maximum => 150, :allow_nil => true
  validates_presence_of :slug
  validates_uniqueness_of :slug
  
    def validate_on_create
    # Using validates_acceptance_of produced an error because it refers to the db
    # table before it exists since the migration loads Profile to refer to the
    # ATTR_LENGTHS constant.
    if self.category.blank?
      errors.add_to_base('Not so fast, bub.')
    end
  end

  acts_as_taggable_on :tags

  define_index do
    indexes title
    indexes description
    indexes short_description
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
    self.service_membership_requests.first(:conditions => { :profile_id => profile.id }).try(:destroy)
    self.service_memberships.create(
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
    service = Service.public.find(:first, :conditions => ['title < ?', title], :order => 'title DESC')
    service || Service.public.first(:order => 'title DESC')
  end

  def next
    service = Service.public.find(:first, :conditions => ['title > ?', title], :order => 'title ASC')
    service || Service.public.first(:order => 'title ASC')
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

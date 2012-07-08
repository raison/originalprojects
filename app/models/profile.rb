class Profile < ActiveRecord::Base
  #------------------------------------------------------------
  # Constants
  #------------------------------------------------------------

  # Field lengths to be used in migrations, html element lengths & validation
  ATTR_LENGTHS = {
    :city               => 30,
    :country            => 30,
    :display_name       => 30,
    :email              => 100,
    :email_verification => 40,
    :first_name         => 30,
    :last_name          => 30,
    :password_hash      => 128,
    :password_salt      => 40,
    :phone_home         => 25,
    :phone_mobile       => 25,
    :phone_office       => 25,
    :remember_token     => 100,
    :state              => 30,
    :username           => 30,
    :zip                => 10
  }

  #------------------------------------------------------------
  # ActiveRecord Declarations
  #------------------------------------------------------------
  has_many :images, :as => :attachable,
    :after_add => :make_connection, :dependent => :destroy

  has_many :memberships, :dependent => :destroy
  has_many :projects, :through => :memberships
  has_many :originated_projects, :through => :memberships,
    :conditions => ["originator = ?", true],
    :source => :project
  has_many :member_projects, :through => :memberships,
    :conditions => ["originator = ?", false],
    :source => :project
  
  has_many :service_memberships, :dependent => :destroy  
  has_many :services, :through => :service_memberships
  has_many :originated_services, :through => :service_memberships,
    :conditions => ["originator = ?", true],
    :source => :service
  has_many :member_services, :through => :service_memberships,
    :conditions => ["originator = ?", false],
    :source => :service

  has_many :interests, :dependent => :destroy
  has_many :followed_projects, :through => :interests,
    :source => :project

  has_many :service_interests, :dependent => :destroy
  has_many :followed_services, :through => :service_interests,
    :source => :service
    
  has_many :membership_requests, :dependent => :destroy
  has_many :service_membership_requests, :dependent => :destroy
  has_many :messages, :foreign_key => "to_id", :dependent => :destroy
  has_many :likes, :dependent => :destroy

  has_many :activities, :dependent => :destroy

  has_many :links, :class_name => 'ProfileLink', :dependent => :destroy
  accepts_nested_attributes_for(:links, :allow_destroy => true,
    :reject_if => lambda { |attrs| attrs['url'].blank? } )

  attr_accessor :tos_accepted

  #------------------------------------------------------------
  # Validations
  #------------------------------------------------------------

  # Validate lengths of all fields listed in ATTR_LENGTHS
  opw_validate_lengths(ATTR_LENGTHS)

  validates_format_of :email, :with => Regex::REGEX_EMAIL, :allow_nil => true,
    :allow_blank => true
  validates_format_of :phone_home, :with => Regex::REGEX_PHONE, :allow_nil => true,
    :allow_blank => true
  validates_format_of :phone_mobile, :with => Regex::REGEX_PHONE, :allow_nil => true,
    :allow_blank => true
  validates_format_of :phone_office, :with => Regex::REGEX_PHONE, :allow_nil => true,
    :allow_blank => true
  validates_format_of :username, :with => /^[A-Za-z\d_]+$/, :message => "can only be alphanumeric with no spaces"
  validates_length_of :city,     :minimum => 2, :allow_nil => true, :allow_blank => true
  validates_length_of :username, :minimum => 3, :allow_nil => true, :allow_blank => true

  validates_presence_of :city
  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :display_name

  validates_uniqueness_of :email, :case_sensitive => false
  validates_uniqueness_of :username, :case_sensitive => false

  def validate_on_create
    # Using validates_acceptance_of produced an error because it refers to the db
    # table before it exists since the migration loads Profile to refer to the
    # ATTR_LENGTHS constant.
    if self.tos_accepted.blank? || self.tos_accepted !~ /[1yYtT]/
      errors.add_to_base('Terms of Use must be accepted.')
    end
  end

  after_create :follow_original_projects_project

  mount_uploader :avatar, AvatarUploader

  acts_as_authentic

  define_index do
    indexes username
    indexes first_name
    indexes last_name
    indexes display_name
    indexes url
    indexes city
    indexes state
    indexes country
    indexes zip
    indexes biography
    indexes education
    indexes employment
    indexes hobbies
    indexes skills
    indexes pastproj
    indexes originalproj
  end

  # Register a new profile:
  # (Hash, String, Boolean) -> [ success::Boolean, Profile ]
  def self.register(attrs, invite_token)
    profile = Profile.new(attrs)
    invite = Invite.find_by_token(invite_token)

    if profile.valid?
      if invite.present? && !invite.accepted?
        profile.save and invite.accept
      else
        profile.errors.add(:invite_token, 'is invalid')
      end
    end

    profile
  end

  #------------------------------------------------------------
  # Instance Methods
  #------------------------------------------------------------

  def self.search_username_and_email(query)
    result = if query.present?
      all(:conditions => ["username LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%"], :limit => 10)
    else
      []
    end

    logger.debug(result.map(&:username))
    result
  end

  def name
    if display_name.present?
    then display_name
    else [first_name, last_name].reject(&:blank?).join(' ')
    end
  end

  def location
    [[city, state].reject(&:blank?).join(', '), zip].reject(&:blank?).join(" ")
  end

  def set_password(password)
    self.password = self.password_confirmation = password
  end

  def sorter
    [ self.first_name.capitalize, self.last_name, self.city ]
  end

  def follow_project(project)
    interests.create(:project => project)
  end

  def join_project(project)
    memberships.create(:project => project) if project.has_open_membership?
  end

  def requested_membership?(project)
    self.membership_requests.all(:conditions => { :project_id => project.id }).any?
  end

  def is_following?(project)
    followed_projects.include?(project)
  end

  def is_involved?(project)
    projects.include?(project)
  end

  def is_member?(project)
    member_projects.include?(project)
  end

  def is_originator?(project)
    originated_projects.include?(project)
  end

  def like_for(project)
    self.likes.first(:conditions => { :project_id => project.id })
  end

  def projects_by_type
    @projects_by_type ||= {
      :originated     => self.originated_projects,
      :collaborating  => self.member_projects,
      :following      => self.followed_projects - self.projects
    }
  end
# service methods -----------------
  def follow_service(service)
    service_interests.create(:service => service)
  end

  def join_service(service)
    service_memberships.create(:service => service) if service.has_open_service_membership?
  end

  def service_requested_membership?(service)
    self.service_membership_requests.all(:conditions => { :service_id => service.id }).any?
  end

  def service_is_following?(service)
    followed_services.include?(service)
  end

  def service_is_involved?(service)
    services.include?(service)
  end

  def service_is_member?(service)
    member_services.include?(service)
  end

  def service_is_originator?(service)
    originated_services.include?(service)
  end

  def service_like_for(service)
    self.likes.first(:conditions => { :service_id => service.id })
  end

  def services_by_type
    @services_by_type ||= {
      :originated     => self.originated_services,
      :collaborating  => self.member_services,
      :following      => self.followed_services - self.services
    }
  end
  alias_method :service_can_edit?, :service_is_originator?
  alias_method :service_can_manage?, :service_is_originator?
  alias_method :service_can_blog?, :service_is_involved?

#--- end service methods

  alias_method :can_edit?, :is_originator?
  alias_method :can_manage?, :is_originator?
  alias_method :can_blog?, :is_involved?

  def deliver_password_reset_instructions
    reset_perishable_token!
    Mailer.deliver_password_reset(self)
  end

  protected

  def <=>( other )
    self.sorter <=> ( other.try( :sorter ) || [] )
  end

  private

  def follow_original_projects_project
    project = Project.find_by_slug('original-projects-inc')
    follow_project(project) if project.present?
  end
end

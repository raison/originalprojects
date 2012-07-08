class InviteRequest < ActiveRecord::Base
  has_one :invite
  
  validates_presence_of :name
  validates_presence_of :city
  validates_presence_of :country
  validates_presence_of :email

  validates_uniqueness_of :email, :allow_nil => true

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_nil => true

  def send_invite
    @invite = self.invite    
    @invite ||= Invite.new(:invite_request => self)
    @invite.save and @invite.send_email
  end

  def email_address
    if name && email
      "#{name} <#{email}>"
    else
      email
    end
  end

  def invited?
    invite.present?
  end

  def accepted?
    invite.present? && invite.accepted?
  end
  
end

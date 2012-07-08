class Invite < ActiveRecord::Base
  validates_presence_of :token
  validates_presence_of :invite_request
  validates_uniqueness_of :invite_request_id

  belongs_to :invite_request

  def initialize_with_defaults(attributes = nil, &block)
    initialize_without_defaults(attributes) do
      self.set_token
      yield self if block_given?
    end
  end

  alias_method_chain :initialize, :defaults
  
  def set_token
    begin
      self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
    end while Invite.find_by_token(self.token)
  end

  def send_email
    Mailer.deliver_invite(self)
  end

  def accept
    update_attributes(:accepted_at => Time.now)
  end
  
  def accepted?
    !accepted_at.nil?
  end
end

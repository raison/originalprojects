class Message < ActiveRecord::Base
  belongs_to :to,   :class_name => "Profile"
  belongs_to :from, :class_name => "Profile"

  validates_presence_of :to
  validates_presence_of :from
  validates_presence_of :subject
  validates_presence_of :body

  after_save :send_copies

  def to=(*receivers)
    @copies = receivers.flatten
    write_attribute :to_id, @copies.shift.try(:id)
  end

  def deliver
    Mailer.deliver_user_specified_message(self) if self.save
  end

  private

  def send_copies
    @copies.each do |profile|
      copy = self.clone
      copy.to = profile
      copy.deliver
    end
  end
end

class Attendance < ActiveRecord::Base
  belongs_to :attendee
  belongs_to :event
  validates_uniqueness_of :attendee_id, :scope => :event_id

  after_destroy :update_event_waitlist

  scope :confirmed, -> {where("NOT waitlisted or waitlisted is NULL")}

  scope :waiting, -> {where("waitlisted").order('created_at ASC')}

  # TODO: refactor: move to service object
  def change_waitlist_to_attending
    self.waitlisted=false
    self.save
    AttendeeMailer.delay.notify_waitlisted(self)
  end

  # TODO: refactor: move to service object
  def update_event_waitlist
    self.event.update_waitlist
  end

end

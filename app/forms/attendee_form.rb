class AttendeeForm < FormObject
  # input parameters for the form
  attribute :name, String
  attribute :company, String
  attribute :email, String
  attribute :mail_list, Boolean
  attribute :event_ids, Array[Fixnum]
  attribute :category_ids, Array[Fixnum]

  # used in the form display
  attribute :events, Array[Event]
  attribute :categories, Array[Category]

  validates_presence_of :name, :company, :email
  validate :event_ids_present

  def attendee
    lookup_by_email || build_attendee
  end

  private

  def event_ids_present
    errors.add(:base, "You have to choose some events.") if event_ids.empty?
  end


  def build_attendee
    Attendee.new(
      name: name,
      company: company,
      email: email,
      mail_list: mail_list
    )
  end

  def lookup_by_email
    Attendee.find_by(email: email)
  end


end


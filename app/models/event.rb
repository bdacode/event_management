class Event < ActiveRecord::Base
  belongs_to :user
  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances
  validates_numericality_of :seats
  validate :validate_date_in_future
  has_attached_file  :image,
                     storage: :s3,
                     s3_protocol: "https",
                     preserve_files: true,
                     :s3_credentials => {
                        bucket: "corecore-events",
                        access_key_id: ENV["s3_id"],
                        secret_access_key: ENV["s3_access_key"]
                      },
                     styles: { :medium => "200x200>", :thumb => "100x100>", display: "100000x79>", medium: "100000x79>", print: "100000x198>" },
                       path: "/image/:id/:style/:filename",
                     :default_url => 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTdsjWnPtvccjwXi18Hbab91KDKChPoWSMCF0maMUBMjSuwAKQL'

  validates_attachment_size :image, less_than: 10.megabytes

  scope :future_events, -> {where("date > ?",Time.now)}

  after_update :update_waitlist

  def confirmed_attendees
    attendees.merge(Attendance.confirmed)
  end

  def waitlisted_attendees
    attendees.merge(Attendance.waitlisted)
  end

  def full?
    available_spots == 0
  end

  def available_spots
    seats - confirmed_spots
  end

  def confirmed_spots
    @confirmed_spots ||= attendances.confirmed.count
  end

  def waitlisted_spots
    @confirmed_spots ||= attendances.waiting.count
  end

  def validate_date_in_future
    if date.blank? || date < Date.today
      errors.add(:date, " should be filled and should be in the future.")
    end
  end

  # TODO: refactor: Move to service object
  def update_waitlist
    waitlisted = self.attendances.waitlisted
    taken = confirmed_spots
    index = 0
    while seats > taken and index < waitlisted.length
      waitlisted[index].change_waitlist_to_attending()
      index+=1
      taken+=1
    end
  end

end

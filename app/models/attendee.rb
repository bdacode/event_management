class Attendee < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances
  has_many :categories, through: :categorizations

  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  def confirmed_events
    events.merge(Attendance.confirmed)
  end

  def waitlisted_events
    events.merge(Attendance.waitlisted)
  end
end

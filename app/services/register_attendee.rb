# Defines the business action / method
class RegisterAttendee < ServiceCall
  include ActiveModel::Validations

  # input params
  attribute :attendee, Attendee
  attribute :event_ids, Array[Fixnum]
  attribute :category_ids, Array[Fixnum]


  def call
    with_exception_catching do
      Attendee.transaction do
        attendee.save!

        attendee.categories << categories
        events.each do |event|
          attendee.attendances.create!(event_id: event.id, waitlisted: event.full?)
        end

        notify_attendee

        result.successful!
      end
    end

    result
  end

  private

  def notify_attendee
    AttendeeMailer.delay.notify_attendee(@attendee)
  end

  def categories
    ::Category.where(id: clean_ids(category_ids))
  end

  def events
    ::Event.where(id: clean_ids(event_ids))
  end

  def new_attendee_params
    {
      email: email,
      name: name,
      company: company,
      mail_list: mail_list,
    }
  end

  def clean_ids(ids)
    ids.delete_if(&:blank?)
  end

end

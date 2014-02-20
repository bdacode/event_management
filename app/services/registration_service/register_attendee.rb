# Pick top level service
module RegistrationService

  # Defines the business action / method
  class RegisterAttendee
    include Virtus.model
    include ActiveModel::Validations

    # input params
    attribute :email, String
    attribute :name, String
    attribute :company, String
    attribute :mail_list, String # not sure what this is used for yet..
    attribute :event_ids, Array[Fixnum]
    attribute :category_ids, Array[Fixnum]

    validate :event_ids_present

    def call
      return false unless valid?

      attendee.categories << categories

      events.each do |event|
        attendee.attendances.new(event_id: event.id, waitlisted: event.full?)
      end

      if attendee.save!
        notify_attendee
        true
      else
        false
      end
    end

    private

    def notify_attendee
      AttendeeMailer.delay.notify_attendee(@attendee)
    end

    def event_ids_present
      errors.add(:base, "You have to choose some events.") if event_ids.empty?
    end

    def attendee
      @attendee ||= (Attendee.find_by_email(email) || Attendee.new(new_attendee_params))
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
end

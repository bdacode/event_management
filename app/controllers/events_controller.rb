class EventsController < ApplicationController

  def index
    @events = Event.future_events.order("date ASC")
    @attendee = Attendee.new

    @attendee_form = AttendeeForm.new(
      events: Event.future_events.order("date ASC"),
      categories: Category.all
    )
  end

end

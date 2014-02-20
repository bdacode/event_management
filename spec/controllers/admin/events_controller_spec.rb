require 'spec_helper'

describe Admin::EventsController do
  let(:admin_user) { create(:user) }
  let(:event) { create(:event) }
  let(:title) { event.title }
  let(:seats) { event.seats }

  login_admin

  def perform(event_params = {})
    event_params.reverse_merge!(title: title, seats: seats)
    put :update, id: event.id, event: event_params
  end

  describe "update" do
    let(:title) { 'New name' }
    let(:seats) { 5}

    it "should update the attributes" do
      perform
      expect(event.reload.attributes).to include(
        "seats" => seats,
        "title" => title
      )
    end

    context "when increasing the seats" do
      include_examples "with two fully booked events" do
        let(:event) { events.first }
        let!(:waitlisted_attendee) { create(:attendance, :waitlisted, event: event).attendee }
        let(:seats) { event.seats + 1 }
        let(:attendee_mailer) { double('attendee_mailer') }

        it "notifies the user that they are not waitlisted" do
          expect(AttendeeMailer).to receive(:delay).and_return(attendee_mailer)
          expect(attendee_mailer).to receive(:notify_waitlisted)
          perform
        end

        it "the waitlisted_attendee is no long waitlisted" do
          perform
          expect(event.confirmed_attendees).to include(waitlisted_attendee)
        end
      end
    end
  end
end

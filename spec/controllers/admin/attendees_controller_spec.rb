require 'spec_helper'

describe Admin::AttendeesController do
  let(:attendee) { create(:attendee) }

  login_admin

  describe "update" do

  end


  describe "destroy" do
    def perform
      delete :destroy, id: attendee.id
    end
    it "should remove the attendee" do
      attendee

      expect {
        perform
      }.to change { Attendee.count }.by(-1)
    end

    context "when one of the events the attendee was attending has a waitlist" do
      include_examples "with two fully booked events" do
        let!(:waitlisted_attendee_1) { create(:attendance, :waitlisted, event: events[0]).attendee }
        let!(:waitlisted_attendee_2) { create(:attendance, :waitlisted, event: events[1]).attendee }
        let(:attendee_mailer) { double('attendee_mailer') }

        it "notifies the two waitlisted attendees" do
          expect(AttendeeMailer).to receive(:delay).and_return(attendee_mailer).twice
          expect(attendee_mailer).to receive(:notify_waitlisted).twice
          perform
        end

        it "the waitlisted_attendee is no long waitlisted" do
          perform
          expect(events[0].confirmed_attendees).to include(waitlisted_attendee_1)
          expect(events[0].confirmed_attendees).to include(waitlisted_attendee_1)
        end
      end
    end
  end
end


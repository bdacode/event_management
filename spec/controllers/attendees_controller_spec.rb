require 'spec_helper'

describe AttendeesController do
  let(:events) { [create(:event), create(:event)] }
  let(:event_ids) { events.map(&:id) }
  let(:categories) { [create(:category), create(:category)] }
  let(:category_ids) { categories.map(&:id) }
  let(:email) { 'test@test.com' }
  let(:create_params) {
    {
      attendee: {
        name: 'name',
        company: 'company',
        mail_list: '',
        email: email,
        event_ids: event_ids,
        category_ids: category_ids
      }
    }
  }

  def perform(attendee_params = {})
    create_params.merge!(attendee_params) unless attendee_params.blank?
    post :create, create_params
  end

  context "successful path" do

    it "creates an attendee" do
      expect {
        perform
      }.to change { Attendee.count }.by(1)
    end

    it "associates the attendee with the events and categories" do
      perform
      attendee = assigns[:attendee]
      expect(attendee.events).to match_array(events)
      expect(attendee.categories).to match_array(categories)
    end

    let(:attendee_mailer) { double('attendee mailer') }

    it 'notifies each attendee' do
      expect(AttendeeMailer).to receive(:delay).and_return(attendee_mailer)
      expect(attendee_mailer).to receive(:notify_attendee)
      perform
    end

    describe "with events that have been previously registered" do
      include_examples "with two fully booked events" do
        # input params
        let(:email) { generate(:email) }

        it "creates the attendance on the waitlist" do
          perform
          attendee = Attendee.last
          expect(attendee.attendances.first).to be_waitlisted
        end
      end
    end

  end

  context "with errors" do
    describe "with missing event params" do
      let(:event_ids) { [] }

      it "redirects to the root on error" do
        perform
        expect(response).to redirect_to(root_path + '#section-signup')
      end

      it "sets the flash message" do
        perform(name: '', email: '')
        expect(flash[:alert]).to eq('You have to choose some events.')
      end
    end


  end

end

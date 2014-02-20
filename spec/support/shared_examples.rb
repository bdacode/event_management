shared_context "with two fully booked events" do
  # setup / background
  let(:attendee) { create(:attendee) }
  let(:events) { [create(:event, seats: 1), create(:event, seats: 1)] }
  let!(:attedances) { [
    create(:attendance, event: events[0], attendee: attendee),
    create(:attendance, event: events[1], attendee: attendee)
  ] }

end

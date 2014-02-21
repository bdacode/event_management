class AttendeesController < ApplicationController

  def create
    form = AttendeeForm.new(attendee_params)
    if form.valid?
      result = RegisterAttendee.call(
        attendee: form.attendee,
        event_ids: form.event_ids,
        category_ids: form.category_ids
      )
    else
      result = ServiceResult.new
    end

    if result.successful?
       render :create
    else
      form.add_errors(result)
      error_message = form.errors.full_messages.join(' and ')
      redirect_to root_path + "#section-signup", alert: error_message
    end
  end

  private

  def attendee_params
    params.require(:attendee).permit([:name, :company, :mail_list, :email, {event_ids: []}, {category_ids: []}])
  end

end

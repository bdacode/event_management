class AttendeesController < ApplicationController

  def create
    result = RegisterAttendee.call(attendee_params)

    if result.successful?
       render :create
    else
      error_message = result.errors.full_messages.join(' and ')
      redirect_to root_path + "#section-signup", alert: error_message
    end
  end

  private

  def attendee_params
    params.require(:attendee).permit([:name, :company, :mail_list, :email, {event_ids: []}, {category_ids: []}])
  end

end

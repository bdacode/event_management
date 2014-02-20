class AttendeesController < ApplicationController

  def create
    register_service = RegistrationService::RegisterAttendee.new(attendee_params)

    if register_service.call
       render :create
    else
      error_message = register_service.errors.full_messages.join(' and ')
      redirect_to root_path + "#section-signup", alert: error_message
    end
  end

  private

  def attendee_params
    params.require(:attendee).permit([:name, :company, :mail_list, :email, {event_ids: []}, {category_ids: []}])
  end

end

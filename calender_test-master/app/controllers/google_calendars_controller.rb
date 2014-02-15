class GoogleCalendarsController < ApplicationController
  before_action :set_calendar, except: [:index]
  def index
    @calendars = GoogleCalendar.all
  end

  def new 
    @calendar = GoogleCalendar.new calendar_params
  end


  def calendar_params
    params.require(:calendar).permit([:calendar_id, :summary, :kind, :location])
  end 


  def set_calendar
    @calendar = GoogleCalendar.find(params[:id])
  end
end

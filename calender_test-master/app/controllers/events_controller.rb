class EventsController < ApplicationController

  def index
    @events = Event.all
    @events_by_date = @events.group_by(&:start)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new event_params
    @event.save
    redirect_to events_path
  end

  def event_params
    params.require(:event).permit([:summary, :location, :start, :end])
  end

end

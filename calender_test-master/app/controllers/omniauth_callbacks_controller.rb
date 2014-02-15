class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    @auth = request.env["omniauth.auth"]
    user = User.from_omniauth(@auth)

    #Use the token from the data to request a list of calendars
    @token = @auth["credentials"]["token"]
    client = Google::APIClient.new
    client.authorization.access_token = @token
    client.authorization.client_id = @client_id
    service = client.discovered_api('calendar', 'v3')
    @result = client.execute(
      :api_method => service.calendar_list.list,
      :parameters => {},
      :headers => {'Content-Type' => 'application/json'})

    @calendars = (JSON.parse(@result.body))["items"]
    
    @calendars.each do |calendar|
      @calendar_id = calendar["id"]
      @summary = calendar["summary"]
      @kind = calendar["kind"]
      @location= calendar["location"]
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"
      Rails.logger.info "@calendar_id: #{@calendar_id.inspect}"
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"

      @result = client.execute(
        :api_method => service.calendars.get,
        :parameters => {calendarId: @calendar_id, eventID: @event_id},
        :body => JSON.dump('summary' => 'test name'),
        :headers => {'Content-Type' => 'application/json'})
      
      @calendar = GoogleCalendar.new 

      @calendar.calendar_id = @calendar_id
      @calendar.summary = @summary
      @calendar.kind = @kind
      @calendar.location = @location
      
      @calendar.save    

   

    @result = client.execute(:api_method => service.events.list,
        :parameters => {calendarId: @calendar_id})

      # Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"
      # Rails.logger.info "@events: #{@events.inspect}"
      # Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"

    @events = (JSON.parse(@result.body))["items"]

    @events.each do |event|

      @event_id = event["id"]
      @summary = event["summary"]
      
      @start = event["start"]
      @start = @start["date"]


      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"
      Rails.logger.info "@start: #{@start.inspect}"
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"
      @end = event["end"]
      @end = @end["date"]

     

      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"
      Rails.logger.info "@end: #{@end.inspect}"
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"

      @events = client.execute(:api_method => service.events.get,
        :parameters => {calendarId: @calendar_id, eventId: @event_id})

      # Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"
      # Rails.logger.info "@events: #{@events.inspect}"
      # Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"
      
      @event = Event.new
      @event.summary = @summary
      @event.start = @start
      
      @event.end = @end
   
      @event.save


    end
  end

    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  alias_method :google_oauth2, :all
  alias_method :facebook, :all

end
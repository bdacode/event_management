class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    @auth = request.env["omniauth.auth"]
    user = User.from_omniauth(@auth)

    #Use the token from the data to request a list of calendars
    @token = @auth["credentials"]["token"]
    client = Google::APIClient.new
    client.authorization.access_token = @token
    service = client.discovered_api('calendar', 'v3')
    @result = client.execute(
      :api_method => service.calendar_list.list,
      :parameters => {},
      :headers => {'Content-Type' => 'application/json'})

    Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"
    Rails.logger.info "@result: #{@result.inspect}"
    Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>"

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

# calendar_id: "tqvtctm085u4ng1nko6nggrg50@group.calendar.google.com"

# client.execute( api_method: service.events.list,
#                 :parameters => {calendarId: "tqvtctm085u4ng1nko6nggrg50@group.calendar.google.com"}, 
#                 :headers => {'Content-Type' => 'application/json'})


# {"kind"=>"calendar#event", "etag"=>"\"TuPKiPtcUnaxp3WU8BefUMu26Bg/MTM4OTY2Mzk2MDUwOTAwMA\"", 
# "id"=>"_60o42gpp852jgb9p8gqj8b9k6kpjiba26gr48b9i711jch9k6d2k6chi6o", "status"=>"confirmed", 
# "htmlLink"=>"https://www.google.com/calendar/event?eid=XzYwbzQyZ3BwODUyamdiOXA4Z3FqOGI5azZrcGppYmEyNmdyNDhiOWk3MTFqY2g5azZkMms2Y2hpNm8gdHF2dGN0bTA4NXU0bmcxbmtvNm5nZ3JnNTBAZw", 
# "created"=>"2014-01-01T00:54:12.000Z", "updated"=>"2014-01-14T01:46:00.509Z", "summary"=>"Lab time", 
# "creator"=>{"email"=>"123and@gmail.com", "displayName"=>"Andrew Ogryzek"}, 
# "organizer"=>{"email"=>"tqvtctm085u4ng1nko6nggrg50@group.calendar.google.com", "displayName"=>"CodeCore", 
#   "self"=>true}, "start"=>{"dateTime"=>"2014-02-17T16:00:00-08:00"}, "end"=>{"dateTime"=>"2014-02-18T00:00:00-08:00"}, 
#   "iCalUID"=>"00AC9AE8-9D54-4539-B46D-28C6E43EC226", "sequence"=>1, "reminders"=>{"useDefault"=>true}} 
class SessionsController < ApplicationController
  def create     
    #What data comes back from OmniAuth?     
    @auth = request.env["omniauth.auth"]
    #Use the token from the data to request a list of calendars
    @token = @auth["credentials"]["token"]
    client = Google::APIClient.new
    client.authorization.access_token = @token
    service = client.discovered_api('calendar', 'v3')
    entry = {
      'id' => 'calendarId'
    }

    # @result = client.execute(:api_method => service.calendar_list.insert,
    #                     :body => JSON.dump(entry),
    #                     :headers => {'Content-Type' => 'application/json'})
    # print result.data.summary

    # @result = client.execute(
    #   :api_method => service.calendars.insert,
    #   :parameters => # not sure what parameters the insert needs,
    #   :body => JSON.dump(@event) # where cal is the object containing at least "summary".
    #   :headers => {'Content-Type' => 'application/json'})

    @result = client.execute(
      :api_method => service.calendar_list.list,
      :parameters => {},
      :body JSON.dump('summary' => 'test name')
      :headers => {'Content-Type' => 'application/json'})
    client.authorization.access_token = @token
    Rails.logger
    # result_body = JSON.parse(@result.body)

  end

end

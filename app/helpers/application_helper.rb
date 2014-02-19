module ApplicationHelper

  # TOOD: refactor: Use built in functionality
  def formatted_date(date)
    date.strftime("%a, %b %d, %Y")
  end
  def formatted_time(date)
    date.strftime("%I:%M %p")
  end
end

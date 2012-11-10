class Event < ActiveResource::Base
  self.site = "http://localhost:3000/api/v1"

  self.prefix = "/api/v1/calendars/:calendar_id/"

  def calendar
    Calendar.find(self.prefix_options[:calendar_id])
  end

  def calendar=(calendar)
    self.prefix_options[:calendar_id] = calendar.id
  end
end
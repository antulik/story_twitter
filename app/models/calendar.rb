class Calendar < ActiveResource::Base
  self.site = "http://localhost:3000/api/v1"

  def events(scope = :all)
    Event.find(scope, :params => {:calendar_id => self.id})
  end

  def event(id)
    events(id)
  end
end
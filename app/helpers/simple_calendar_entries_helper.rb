module SimpleCalendarEntriesHelper

  def some_time(date, hour, minute)
    #Time.local(date.year, date.month, date.day, hour, minute) 
    Time.utc(date.year, date.month, date.day, hour, minute)
  end

end

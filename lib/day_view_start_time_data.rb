module DayViewStartTimeData
  def day_start_time
    Thread.current[:day_start_time]
  end

  def self.day_start_time=(time)
    Thread.current[:day_start_time] = time
  end
end

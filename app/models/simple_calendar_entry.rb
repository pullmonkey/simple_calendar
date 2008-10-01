class SimpleCalendarEntry < ActiveRecord::Base
  belongs_to :simple_calendar

  validates_presence_of :name, :message => "^You must enter a name first"
  validate :end_time_after_start_time

  named_scope :all_by_month_and_year,
              lambda{|month, year| {
                :conditions => ["start_time >= ? and start_time <= ?", 
                                Date.civil(year, month, 1),
                                Date.civil(year, month, 
                                           Time.days_in_month(month, year))]
              }}
  def end_time_after_start_time
    if end_time < start_time
      errors.add_to_base("The start time can't be later than the end time.")
    end
  end

  def date_time
    logger.error "start time: #{start_time.to_time}"
    logger.error "end time: #{end_time.to_time}"
    if start_time.to_date == end_time.to_date
      "#{start_time.to_time.strftime('%A, %B %d, %Y  %I:%M %p')} - #{end_time.to_time.strftime('%I:%M %p')}"
    else
      "#{start_time.to_time.strftime('%A, %B %d, %Y  %I:%M %p')} - #{end_time.to_time.strftime('%A, %B %d, %Y  %I:%M %p')}"
    end
  end

  def touching?(entry)
    return true if entry.start_time == self.start_time or entry.end_time == self.end_time
    return false if entry.start_time == self.end_time or entry.end_time == self.start_time
    return true if entry.start_time.between?(self.start_time, self.end_time) or self.start_time.between?(entry.start_time, entry.end_time)
    return true if entry.end_time.between?(self.start_time, self.end_time) or self.end_time.between?(entry.start_time, entry.end_time)
    return false
  end

  def all_touching(entries)
    entries.select{|i| i.touching?(self)}# - [self]
  end

  def span
    time = end_time.minus_with_duration(start_time)
    time = time.to_i / 60
    if (time / 30.0).to_f > (time / 30).to_i 
      s = (time / 30).to_i + 1
    else
      s = time / 30
    end
    return s
  end

  def date
    start_time.to_date
  end

  def time
    start_time.to_s(:just_time)
  end

  def e_time
    end_time.to_s(:just_time)
  end
end

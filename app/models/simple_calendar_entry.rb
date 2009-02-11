class SimpleCalendarEntry < ActiveRecord::Base
  acts_as_taggable

  belongs_to :simple_calendar

  validates_presence_of :name, :message => "^You must enter a name first"
  validate :end_time_after_start_time

  named_scope :all_by_month_and_year,
              lambda{|month, year| {
                :conditions => ["start_time >= ? and start_time <= ?", 
                                Date.civil(year, month, 1),
                                Date.civil(month == 12 ? year + 1 : year, month == 12 ? 1 : month + 1, 1)] 
              }}

  named_scope :all_future_entries, {
                :conditions => ["start_time >= ?", 
                                Time.today]
              }
              
  def sibling_entries(month, year)
    entries = self.simple_calendar.simple_calendar_entries.
         all_by_month_and_year(month, year).
         #sort{|a,b| a.start_time <=> b.start_time}.
         group_by(&:date)
  end

  def end_time_after_start_time
    if end_time < start_time
      errors.add_to_base("The start time can't be later than the end time.")
    end
  end

  def date_time
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

#  def all_touching(entries)
#    touching_entries = entries.select{|i| i.touching?(self)} - [self]
#    #logger.error "*********************************************************************************"
#    #logger.error "entry being tested: " + self.name
#    #logger.error "\ntouching_entries at start: " + touching_entries.map{|e| e.name}.inspect
#    if touching_entries and touching_entries.size > 1
#      touching_entries.each do |entry|
#        if touching_entries and touching_entries.size > 1
#          not_touching = true
#          touching_entries.each do |blah|
#            if !(entry == blah)
#              not_touching = false if blah.touching?(entry)
#            end
#          end
#        end
#        #logger.error "\nnot touching: #{not_touching}"
#        touching_entries = touching_entries - [entry] if not_touching
#      end
#    end
#    #logger.error "\ntouching_entries: " + touching_entries.map{|e| e.name}.inspect
#    #logger.error "*********************************************************************************"
#    return touching_entries + [self]
#  end

  def all_touching_max_and_min(entries)
    touching_entries = entries.select{|i| i.touching?(self)}
    minute_increment = 15
    lcv = 0
    max = [] 
    min = touching_entries
    while((self.start_time + lcv * minute_increment) < self.end_time)
      time = self.start_time + (lcv * minute_increment).minutes
      num = []
      touching_entries.each do |entry|
        num << entry if time.between?(entry.start_time, entry.end_time)
      end
      max = num if (num.size > max.size)
      min = num if (num.size < min.size)
      lcv += 1
    end
    return min, max 
  end

  def top
    self.start_time.hour * 60 + self.start_time.min
  end

  def height
    self.total_time_minutes - 2
  end

  def width(day, month, year)
    entries = sibling_entries(month, year)[Date.civil(year, month, day)]
    min, max = self.all_touching_max_and_min(entries)
    (90 / max.size)
  end

  def left(day, month, year)
    entries = sibling_entries(month, year)[Date.civil(year, month, day)]
    min, max = self.all_touching_max_and_min(entries)
    left = 5
    #index = sibling_entries(month, year)[Date.civil(year, month, day)].index(self)
    logger.error "*****************************************************************************"
    logger.error "SELF: #{self.inspect}"
    logger.error "MAX ARRAY: " + max.map{|e| [e.id, e.start_time]}.join(", ") + "\n\n"
    index = max.index(self)
    left += self.width(day, month, year) * index if index
    left += index
    return left
  end

  def total_time_minutes
    (end_time - start_time) / 60
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

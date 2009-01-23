module SimpleCalendarHelper

  def home_path
    return session[:simple_calendar_path] if not session[:simple_calendar_path].empty?
    return session[:simple_calendar_prefix] if not session[:simple_calendar_prefix].empty?
    return "http://#{request.env['HTTP_HOST']}"
  end

  def path_for_new_calendar_entry_day(hour, min)
    "#{home_path}#{new_simple_calendar_entry_path}/#{Date.new(@year, @month, @day)}?mode=day&hour=#{hour}&mins=#{min}"
  end

  def path_for_new_calendar_entry_month(day)
    "#{home_path}#{new_simple_calendar_entry_path}/#{Date.new(@year, @month, day)}"
  end

  def path_to_day_view(day)
    "#{home_path}/simple_calendar/day_view?date=#{Date.new(@year, @month, day)}"
  end

  def day_view_link(day)
    link_to_remote "<div class='day'>#{day}</div>", :url => path_to_day_view(day),
                                                    :complete => "tabsRoundedCorners()"
  end

  def small_day_view_link(day)
    link_to day, path_to_day_view(day)
  end
end

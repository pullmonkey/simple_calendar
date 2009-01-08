module SimpleCalendarHelper

  def home_path
    return session[:simple_calendar_path] if not session[:simple_calendar_path].empty?
    return session[:simple_calendar_prefix] if not session[:simple_calendar_prefix].empty?
    return "http://#{request.env['HTTP_HOST']}"
  end

end

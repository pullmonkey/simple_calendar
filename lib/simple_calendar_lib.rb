# SimpleCalendar
#
# Form Builder
class SimpleCalendarFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
            %w(datetime_select) - 
            %w(hidden_field label fields_for)

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      label = label(field, options[:label], :class => options[:label_class])
      @template.content_tag(:p, @template.content_tag(:b, label) + ":<br/>" + super)
    end
  end
end
 
ActionController::Base.class_eval do
  self.append_view_path File.join(File.dirname(__FILE__), '..', 'app', 'views')
end

ActionView::Base.class_eval do
  alias render_otherwise render
  def render(options = {}, local_assigns = {}, &block)
    if options.is_a?(Hash) and options[:simple_calendar]
      render_simple_calendar(options, local_assigns, &block)
    else
      render_otherwise(options, local_assigns, &block)
    end
  end

  def render_simple_calendar(options = {}, local_assigns = {}, &block)
    @mode  = options[:mode] || 'month'
    @layout = options.has_key?(:layout) ? options[:layout] : true
    @date  = Date.today 
    @day   = (options[:day]   || @date.day).to_i
    @year  = (options[:year]  || @date.year).to_i
    @month = (options[:month] || @date.month).to_i
    @base  = options[:base]
    @days  = Time.days_in_month(@month,@year)    
    @date  = Date.new(@year, @month, @day)
    @first_week_day = (@date - @date.day.days + 1.day).wday
    @calendar_path = options[:return_to] || "/"
    @calendar_name = options[:simple_calendar] || "default_simple_calendar"
    @simple_calendar = SimpleCalendar.find_or_create_by_name(@calendar_name)
    session[:simple_calendar_name] = @calendar_name
    session[:simple_calendar_path] = @calendar_path
    @entries = @simple_calendar.simple_calendar_entries.
                all_by_month_and_year(@month, @year).
                group_by(&:date)
    logger.error "layout: " + @layout.to_s
    if @layout
      render :partial => 'shared/calendar'
    else
      if @mode == 'day'
        render :partial => 'shared/day'
      else
        render :partial => 'shared/simple_calendar'
      end
    end
  end
end

module SimpleCalendarMod
  module CalendarRouting
    module MapperExtensions
      def simple_calendar
        $simple_calendar_path ||= ""
        @set.add_route("#{$simple_calendar_path}/:controller/:action/:id.:format", {:controller => 'simple_calendar'})
        @set.add_route("#{$simple_calendar_path}/:controller/:action/:id",         {:controller => 'simple_calendar'})
        @set.add_route("#{$simple_calendar_path}/:controller/:action",             {:controller => 'simple_calendar'})
        
        @set.add_route("#{$simple_calendar_path}/simple_calendar_entries/:action/:id.:format", {:controller => 'simple_calendar'})
        @set.add_route("#{$simple_calendar_path}/:controller/:action/:id",         {:controller => 'simple_calendar'})
        @set.add_route("#{$simple_calendar_path}/:controller/:action",             {:controller => 'simple_calendar'})
      end
    end
  end
end

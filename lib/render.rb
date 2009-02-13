module SimpleCalendarMod
  module Render
    def self.included(base)
      base.extend(ActionView)
      base.class_eval do
        def render_with_simple_calendar(options = {}, local_assigns = {}, &block)
          if options.is_a?(Hash) and options[:simple_calendar]
            @calendar_name = options[:simple_calendar] || "default_simple_calendar"
            initialize_simple_calendar(options)
            render_simple_calendar(options, local_assigns, &block)
          else
            render_without_simple_calendar(options, local_assigns, &block)
          end
        end
        alias_method_chain :render, :simple_calendar

        def render_with_small_simple_calendar(options = {}, local_assigns = {}, &block)
          if options.is_a?(Hash) and options[:small_simple_calendar]
            @calendar_name = options[:small_simple_calendar] || "default_simple_calendar"
            initialize_simple_calendar(options)
            render_small_simple_calendar(options, local_assigns, &block)
          else
            render_without_small_simple_calendar(options, local_assigns, &block)
          end
        end
        alias_method_chain :render, :small_simple_calendar

        def render_with_simple_calendar_upcoming_events(options = {}, local_assigns = {}, &block)
          if options.is_a?(Hash) and options[:simple_calendar_upcoming_events]
            @calendar_name = options[:simple_calendar_upcoming_events] || "default_simple_calendar"
            initialize_simple_calendar(options)
            render_simple_calendar_upcoming_events(options, local_assigns, &block)
          else
            render_without_simple_calendar_upcoming_events(options, local_assigns, &block)
          end
        end
        alias_method_chain :render, :simple_calendar_upcoming_events

        def initialize_simple_calendar(options = {})
          @admin = options[:admin] || false
          session[:simple_calendar_admin] = @admin

          @prefix = options[:prefix] || session[:simple_calendar_prefix] || ""
          session[:simple_calendar_prefix] = @prefix

          @mode  = options[:mode] || 'month'
          @layout = options.has_key?(:layout) ? options[:layout] : true
          @date  = Date.today 
          @date = params[:date].to_date if !params[:date].nil?
          @year  = (options[:year]  || @date.year).to_i
          @month = (options[:month] || @date.month).to_i
          @days  = Time.days_in_month(@month, @year)    
          @day = @mode == 'month' ? 1 : @date.day
          @date  = Date.new(@year, @month, @day)

          @first_week_day = (@date - @date.day.days + 1.day).wday
          @calendar_path = options[:return_to] || session[:simple_calendar_path] || ""
          $simple_calendar_path = @calendar_path
          @simple_calendar = SimpleCalendar.find_or_create_by_name(@calendar_name)
          session[:simple_calendar_name] = @calendar_name
          session[:simple_calendar_path] = @calendar_path
          @entries = @simple_calendar.simple_calendar_entries.
                      all_by_month_and_year(@month, @year)

          @selected_tag = options[:tag] || ""
          session[:simple_calendar_selected_tag] = @selected_tag
          @entries = @entries.find_tagged_with(@selected_tag) if not @selected_tag.blank?

          @entries = @entries.sort{|a,b| a.start_time <=> b.start_time}.
                              group_by(&:date)
        end

        def render_simple_calendar(options = {}, local_assigns = {}, &block)
          @show_wiki_entries_button = options.has_key?(:show_wiki_entries) ? options[:show_wiki_entries] : false
          @show_wiki_entries_button = session[:simple_calendar_show_wiki_entries_button] if !options.has_key?(:show_wiki_entries) and session[:simple_calendar_show_wiki_entries_button]
          session[:simple_calendar_show_wiki_entries_button] = @show_wiki_entries_button

          @use_tags = options.has_key?(:taggable) ? options[:taggable] : false
          @use_tags = session[:simple_calendar_taggable] if !options.has_key?(:taggable) and session[:simple_calendar_taggable]
          session[:simple_calendar_taggable] = @use_tags
          @all_tags = SimpleCalendarEntry.tag_counts if @use_tags

          @link_length = options[:entry_link_length] || session[:simple_calendar_link_length] || 15
          session[:simple_calendar_link_length] = @links_length

          if @layout
            render :partial => 'shared/calendar'
          else
            if @mode == 'day'
              @hours = ['12am', '1am', '2am', '3am', '4am', '5am', '6am', '7am', '8am', '9am', '10am', '11am', 
                        '12pm', '1pm', '2pm', '3pm', '4pm', '5pm', '6pm', '7pm', '8pm', '9pm', '10pm', '11pm']
              @entries = @entries[Date.civil(@year, @month, @day)]
              render :partial => 'shared/day'
            else
              render :partial => 'shared/month'
            end
          end
        end

        def render_small_simple_calendar(options = {}, local_assigns = {}, &block)
          session[:simple_calendar_link_path] = options[:path] || "/"
          @layout ?
            (render :partial => 'shared/small_calendar') :
            (render :partial => 'shared/small_inner_calendar')
        end

        def render_simple_calendar_upcoming_events(options = {}, local_assigns = {}, &block)
          @items = options[:items]
          @path = options[:path] || "/"
          @name_length = options[:entry_name_length] || 100
          @entries = @simple_calendar.simple_calendar_entries.all_future_entries
          @entries = @entries.find_tagged_with(@selected_tag) if not @selected_tag.blank?
          @entries.sort!{|a,b| a.start_time <=> b.start_time}
          render :partial => 'shared/upcoming_events'
        end
      end
    end
  end
end

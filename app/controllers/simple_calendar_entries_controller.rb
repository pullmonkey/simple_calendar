class SimpleCalendarEntriesController < ApplicationController
  # For Rails version 2.0 to 2.1
  #self.view_paths << File.join(File.dirname(__FILE__), '..', 'views')
  # For Rails versions less than 2.0
  #self.template_root = File.join(File.dirname(__FILE__), '..', 'views')

  before_filter :set_simple_calendar_defaults

  def new
    @mode = params[:mode] ? params[:mode] : "month"
    @date = params[:id].to_time.utc
    if !@admin
      render_calendar
      return
    end
    if !params[:hour].nil?
      @hour = params[:hour].to_i
      @date += @hour.hours
    else
      @date += 6.hours
    end
    @date += params[:mins].to_i.minutes if params[:mins]
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.new(:start_time => @date.to_time, :end_time => @date.to_time + 1.hour)
    render :partial => 'form', :layout => false
  end

  def create
    @mode = params[:simple_calendar_entry][:mode]
    if !@admin
      render_calendar
      return
    end
    params[:simple_calendar_entry].delete(:mode)
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.new(params[:simple_calendar_entry])
    @simple_calendar_entry.save ? 
      flash[:notice] = "Calendar Entry Saved" : 
      flash[:error] = "Calendar Entry Could Not Be Saved"
    @date = @simple_calendar_entry.start_time.to_date
    render_calendar
  end

  def show
    @mode = params[:mode] ? params[:mode] : "month"
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.find(params[:id])
    render :layout => false
  end

  def edit
    @mode = params[:mode] ? params[:mode] : "month"
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.find(params[:id])
    @date = @simple_calendar_entry.start_time.to_date
    if !@admin
      render_calendar
      return
    end
    render :partial => 'form', :layout => false
  end

  def update
    @mode = params[:simple_calendar_entry][:mode]
    params[:simple_calendar_entry].delete(:mode)
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.find(params[:id])
    if !@admin
      render_calendar
      return
    end
    @simple_calendar_entry.update_attributes(params[:simple_calendar_entry]) ? 
      flash[:notice] = "Calendar Entry Updated" : 
      flash[:error] = "Calendar Entry Could not be Updated"
    @date = @simple_calendar_entry.start_time.to_date
    render_calendar
  end

  def delete
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.find(params[:id])
    @mode = params[:mode] ? params[:mode] : "month"
    if @admin
      @confirm = "Are you sure you want to delete this entry"
      @simple_calendar_entry.destroy ?
        flash[:notice] = "Event Deleted" :
        flash[:error] = "Event Could not be Deleted!"
    else
      flash[:error] = "You are not an admin"
    end
    @date = @simple_calendar_entry.start_time.to_date
    render_calendar
  end 

  def entries_without_time
    @future_entries = @simple_calendar.simple_calendar_entries.all_future_entries.sort{|a,b| a.start_time <=> b.start_time}
    render :layout => false
  end

private

  def set_simple_calendar_defaults
    @simple_calendar = SimpleCalendar.find_or_create_by_name(session[:simple_calendar_name])
    @calendar_path = "/"
    @calendar_path = session[:simple_calendar_prefix] if not session[:simple_calendar_prefix].empty?
    @calendar_path = session[:simple_calendar_path] if not session[:simple_calendar_path].empty?
    @admin = session[:simple_calendar_admin]
  end

  def render_calendar
    redirect_to @calendar_path + "?mode=#{@mode}&date=#{@date}"
  end
end

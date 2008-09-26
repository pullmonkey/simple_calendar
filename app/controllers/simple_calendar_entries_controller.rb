class SimpleCalendarEntriesController < ApplicationController
  before_filter :set_simple_calendar_defaults

  def new
    @mode = params[:mode] ? params[:mode] : "month"
    year, month, day = params[:id].split("_")
    @date = Date.civil(year.to_i, month.to_i, day.to_i).to_time.utc
    logger.error "*************************************************************************************"
    logger.error "Date: #{@date}"
    if !params[:hour].nil?
      @hour = params[:hour].to_i
      @date -= 6.hours
      @date += @hour.hours
      logger.error "Date after: #{@date.to_time}"
    end
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.new(:start_time => @date.to_time, :end_time => @date.to_time + 1.hour)
    render :partial => 'form'
  end

  def create
    @mode = params[:simple_calendar_entry][:mode]
    params[:simple_calendar_entry].delete(:mode)
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.new(params[:simple_calendar_entry])
    @simple_calendar_entry.save ? 
      flash[:notice] = "Calendar Entry Saved" : 
      flash[:error] = "Calendar Entry Could Not Be Saved"
    logger.error "calendar_path: " + @calendar_path.to_s
    #redirect_to @calendar_path, :date => (@simple_calendar_entry ? "#{@simple_calendar_entry.start_time.to_date}" : nil)
    redirect_to :controller => "simple_calendar", :action => @mode == "day" ? "day_view" : "month_view", :date => (@simple_calendar_entry ? "#{@simple_calendar_entry.start_time.to_date}" : nil)
  end

  def show
    @mode = params[:mode] ? params[:mode] : "month"
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.find(params[:id])
    render :layout => false
  end

  def edit
    @mode = params[:mode] ? params[:mode] : "month"
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.find(params[:id])
    render :partial => 'form'
  end

  def update
    @mode = params[:simple_calendar_entry][:mode]
    params[:simple_calendar_entry].delete(:mode)
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.find(params[:id])
    @simple_calendar_entry.update_attributes(params[:simple_calendar_entry]) ? 
      flash[:notice] = "Calendar Entry Updated" : 
      flash[:error] = "Calendar Entry Could not be Updated"
    #redirect_to @calendar_path
    redirect_to :controller => "simple_calendar", :action => @mode == "day" ? "day_view" : "month_view", :date => "#{@simple_calendar_entry.start_time.to_date}"
  end

  def delete
    @simple_calendar_entry = @simple_calendar.simple_calendar_entries.find(params[:id])
    @confirm = "Are you sure you want to delete this entry"
    @simple_calendar_entry.destroy ?
      flash[:notice] = "Event Deleted" :
      flash[:error] = "Event Could not be Deleted!"
    #redirect_to @calendar_path
    redirect_to :controller => "simple_calendar", :action => "month_view", :date => "#{@simple_calendar_entry.start_time.to_date}"
  end 

private

  def set_simple_calendar_defaults
    @simple_calendar = SimpleCalendar.find_or_create_by_name(session[:simple_calendar_name])
    #@calendar_path = session[:simple_calendar_path]
    @calendar_path = home_path 
  end
end

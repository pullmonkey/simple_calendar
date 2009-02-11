class SimpleCalendarController < ApplicationController
  # For Rails version 2.0 to 2.1
  #self.view_paths << File.join(File.dirname(__FILE__), '..', 'views')
  # For Rails versions less than 2.0
  #self.template_root = File.join(File.dirname(__FILE__), '..', 'views')

  def index
  end
  
  def refresh_date
    render :update do |page| 
      page.replace_html :inner_calendar, :simple_calendar => session[:simple_calendar_name], 
                                         :admin => session[:simple_calendar_admin], 
                                         :month => params[:month], :year => params[:year],
                                         :tag => params[:tag],
                                         :layout => false 
    end
  end

  def small_refresh_date
    month = params[:month].to_i
    year  = params[:year].to_i
    if month == 0
      year -= 1
      month = 12
    end
    if month == 13
      year += 1
      month = 1
    end
    render :update do |page|
      page.replace_html :small_inner_calendar, :small_simple_calendar => session[:simple_calendar_name], 
                                         :admin => session[:simple_calendar_admin], 
                                         :year => year, :month => month,
                                         :layout => false
    end
  end

  def day_view
    @mode = 'day'
    if !params[:date].nil?
      @year, @month, @day = params[:date].split('-')
    else
      @year = Time.now.year
      @month = Time.now.month
      @day  = Time.now.day
    end
    @date = Date.new(@year.to_i, @month.to_i, @day.to_i)

    @hours = ['12am', '1am', '2am', '3am', '4am', '5am', '6am', '7am', '8am', '9am', '10am', '11am', 
              '12pm', '1pm', '2pm', '3pm', '4pm', '5pm', '6pm', '7pm', '8pm', '9pm', '10pm', '11pm']

    render :update do |page|
      page.replace_html :tabs_column, :partial => 'shared/tabs'
      page.replace_html :inner_calendar, :simple_calendar => session[:simple_calendar_name], 
                                         :admin => session[:simple_calendar_admin], 
                                         :date => @date,
                                         :mode => @mode,
                                         :tag  => params[:tag],
                                         :layout => false 
    end
  end 

  def month_view
    @mode  = 'month'
    if !params[:date].nil?
      @date  = params[:date].to_date
      @day   = @date.day
      @month = @date.month
      @year  = @date.year
    else 
      @year = Time.now.year
      @month = Time.now.month
      @day = Time.now.day
    end
    @date = Date.new(@year.to_i, @month.to_i, @day.to_i)

    render :update do |page|
      page.replace_html :tabs_column, :partial => 'shared/tabs'
      page.replace_html :inner_calendar, :simple_calendar => session[:simple_calendar_name], 
                                         :admin => session[:simple_calendar_admin], 
                                         :date => @date,
                                         :mode => @mode,
                                         :tag  => params[:tag],
                                         :layout => false 
    end
  end

  def render_all_with_tag
    render :update do |page|
      page.replace_html :inner_calendar, :simple_calendar => session[:simple_calendar_name], 
                                         :admin => session[:simple_calendar_admin], 
                                         :date => @date,
                                         :mode => @mode,
                                         :layout => false,
                                         :tag => params[:tag]
    end
  end
end

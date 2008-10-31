class SimpleCalendarController < ApplicationController
  # For Rails version 2.0 to 2.1
  #self.view_paths << File.join(File.dirname(__FILE__), '..', 'views')
  # For Rails versions less than 2.0
  #self.template_root = File.join(File.dirname(__FILE__), '..', 'views')

  def index
  end
  
  def refresh_month
    render :update do |page| 
      page.replace_html :inner_calendar, :simple_calendar => session[:simple_calendar_name], :admin => session[:simple_calendar_admin], :layout => false, :month => params[:month], :year => params[:year]
    end
  end

  def refresh_year
    render :update do |page|
      page.replace_html :inner_calendar, :simple_calendar => session[:simple_calendar_name], :admin => session[:simple_calendar_admin], :layout => false, :year => params[:year], :month => params[:month]
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

    render :action => 'index'
  end 

  def month_view
    @mode  = 'month'
    if !params[:date].nil?
      @date  = params[:date].to_date
      @day   = 1
      @month = @date.month
      @year  = @date.year
    else 
      @year = Time.now.year
      @month = Time.now.month
      @day = Time.now.day
    end
    @date = Date.new(@year.to_i, @month.to_i, @day.to_i)

    render :action => 'index'
  end
end

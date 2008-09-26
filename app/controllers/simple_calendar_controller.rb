class SimpleCalendarController < ApplicationController

  def index
  end
  
  def refresh_month
    render :update do |page| 
      page.replace_html :inner_calendar, :simple_calendar => session[:simple_calendar_name], :layout => false, :month => params[:month], :year => params[:year]
    end
  end

  def refresh_year
    render :update do |page|
      page.replace_html :inner_calendar, :simple_calendar => session[:simple_calendar_name], :layout => false, :year => params[:year], :month => params[:month]
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
      @day   = Time.now.day
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

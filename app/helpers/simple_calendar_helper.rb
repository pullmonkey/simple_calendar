module SimpleCalendarHelper

  def home_path
    return "http://#{request.env['HTTP_HOST']}"
  end

  def button_image(name)
    #get the name for the button and create a tag
    return "<img src='#{home_path}/images/SegmentLeftN.png' /><input style='background-image: url(#{home_path}/images/SegmentFillN.png); padding: 0px 4px 4px 4px; vertical-align:top;' type='image' value= #{name} /><img src='#{home_path}/images/SegmentRightN.png' />"
  end

  def tab_link(name)
    if @mode == nil
      @mode = 'month'
    end
    if @mode == name.downcase 
      @class = "class='tab_active'"
      @image = "_active"
    else
      @class = "class='tab'"
      @image = ""
    end
    @date = params[:date]
    if !@date
      @date = Date.today
    end
    link_to "
      <table #{@class} cellpadding=\"0\" cellspacing=\"0\">
        <tr>
          <td><img src='#{home_path}/images/small_top_left#{@image}.png' /></td>
          <td></td>
          <td><img src='#{home_path}/images/small_top_right#{@image}.png' /></td>
        </tr>
        <tr>
          <td></td>
          <td>#{name}</td>
          <td></td>
        </tr>
      </table>",
      {:controller => 'simple_calendar', :action => "#{name.downcase}_view", :date => @date}, :method => :post
  end 

  def tab(name)
    if @mode == nil
      @mode == "month"
    end
    if @mode == name.downcase
      @class = "class='tab_active'"
      @image = "_active"
    else
      @class = " class='tab'"
      @image = ""
    end
    return "
      <table #{@class} cellpadding=\"0\" cellspacing=\"0\">
        <tr>
          <td><img src='#{home_path}/images/small_top_left#{@image}.png' /></td>
          <td></td>
          <td><img src='#{home_path}/images/small_top_right#{@image}.png' /></td>
        </tr>
        <tr>
          <td></td>
          <td>#{name}</td>
          <td></td>
        </tr>
      </table>"
  end
end

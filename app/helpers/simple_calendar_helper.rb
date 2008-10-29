module SimpleCalendarHelper

  def home_path
    return session[:simple_calendar_path] if not session[:simple_calendar_path].empty?
    return session[:simple_calendar_prefix] if not session[:simple_calendar_prefix].empty?
    return "http://#{request.env['HTTP_HOST']}"
  end

  def button_image(name)
    #get the name for the button and create a tag
    return "#{image_tag('SegmentLeftN.png')}<input style='background-image: url(#{session[:simple_calendar_prefix]}/images/SegmentFillN.png); padding: 0px 4px 4px 4px; vertical-align:top;' type='image' value= #{name} />#{image_tag('SegmentRightN.png')}"
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
          <td>#{image_tag('small_top_left'+@image+'.png')}</td>
          <td></td>
          <td>#{image_tag('small_top_right'+@image+'.png')}</td>
        </tr>
        <tr>
          <td></td>
          <td>#{name}</td>
          <td></td>
        </tr>
      </table>"
  end
end

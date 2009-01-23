window.onload = function() {
  if(!NiftyCheck())
    return;
  Rounded("div#calendar","all","#FFF",document.getElementById('calendar').getStyle('background-color'),"smooth");
  Rounded("li#active_tab","top","#FFF",document.getElementById('active_tab').getStyle('background-color'),"smooth");
  Rounded("li#tab","top","#FFF",document.getElementById('tab').getStyle('background-color'),"smooth");
}

function tabsRoundedCorners() {
  if(!NiftyCheck())
    return;
  Rounded("li#active_tab","top","#FFF",document.getElementById('active_tab').getStyle('background-color'),"smooth");
  Rounded("li#tab","top","#FFF",document.getElementById('tab').getStyle('background-color'),"smooth");
}

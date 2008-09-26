# Include hook code here
require 'simple_calendar_lib'
require File.join(directory, 'app', 'helpers') + "/simple_calendar_helper"
require File.join(directory, 'app', 'helpers') + "/simple_calendar_entries_helper"

ActionView::Base.send :include, SimpleCalendarHelper
ActionView::Base.send :include, SimpleCalendarEntriesHelper


class << ActionController::Routing::Routes;self;end.class_eval do
  # dont clear the existing routes when setting up new routes
  define_method :clear!, lambda {}
end

ActionController::Routing::Routes.draw do |map|
  map.resources 'simple_calendar_entries'
end

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :just_time => "%I:%M %p"
)

model_path      = File.join(directory, 'app', 'models')
$LOAD_PATH << model_path
Dependencies.load_paths << model_path

controller_path = File.join(directory, 'app', 'controllers')
$LOAD_PATH << controller_path
Dependencies.load_paths << controller_path
config.controller_paths << controller_path

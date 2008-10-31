# Install hook code here
require 'ftools'

puts IO.read(File.join(File.dirname(__FILE__), 'README'))
puts "\n\n====================================================================="
puts "\n\nMoving all required javascript, css files, and images to your public directory..."
`rake simple_calendar:install`

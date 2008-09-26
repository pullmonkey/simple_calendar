# desc "Explaining what the task does"
namespace :simple_calendar do
  
  PLUGIN_ROOT = File.dirname(__FILE__) + '/../'

  desc 'Installs all required public files to the public/ folder'
  task :install do
    FileList[PLUGIN_ROOT + '/public/javascripts/*.js'].each do |f|
      puts "ADDING /public/javascripts/" + File.basename(f)
      FileUtils.cp f, RAILS_ROOT + '/public/javascripts'
    end
    FileList[PLUGIN_ROOT + '/public/stylesheets/*.css'].each do |f|
      puts "ADDING /public/stylesheets/" + File.basename(f)
      FileUtils.cp f, RAILS_ROOT + '/public/stylesheets'
    end
    FileList[PLUGIN_ROOT + '/public/images/*'].each do |f|
      puts "ADDING /public/images/" + File.basename(f)
      FileUtils.cp f, RAILS_ROOT + '/public/images'
    end
  end

  desc 'Uninstalls all public files associated with simple_calendar'
  task :uninstall do
    puts "REMOVING /public/javascripts/jqModal.js"
    FileUtils.rm RAILS_ROOT + '/public/javascripts/jqModal.js'
    puts "REMOVING /public/javascripts/jquery.js"
    FileUtils.rm RAILS_ROOT + '/public/javascripts/jquery.js'
    puts "REMOVING /public/stylesheets/jqModal.css"
    FileUtils.rm RAILS_ROOT + '/public/stylesheets/jqModal.css'
    puts "REMOVING /public/stylesheets/simple_calendar.css"
    FileUtils.rm RAILS_ROOT + '/public/stylesheets/simple_calendar.css'
    FileList[PLUGIN_ROOT + '/public/images/*'].each do |image|
      image = File.basename(image)
      puts "REMOVING /public/images/" + image
      FileUtils.rm RAILS_ROOT + '/public/images/' + image
    end
  end
end

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
    FileList[PLUGIN_ROOT + '/public/javascripts/*.js'].each do |file|
      file = File.basename(file)
      puts "REMOVING /public/javascripts/" + file
      FileUtils.rm RAILS_ROOT + '/public/javascripts/' + file
    end
    FileList[PLUGIN_ROOT + '/public/stylesheets/*.css'].each do |file|
      file = File.basename(file)
      puts "REMOVING /public/stylesheets/" + file
      FileUtils.rm RAILS_ROOT + '/public/stylesheets/' + file
    end
    FileList[PLUGIN_ROOT + '/public/images/*'].each do |image|
      image = File.basename(image)
      puts "REMOVING /public/images/" + image
      FileUtils.rm RAILS_ROOT + '/public/images/' + image
    end
  end
end

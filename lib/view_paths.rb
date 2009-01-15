module SimpleCalendarMod
  module ViewPaths
    def self.included(klas)
      klas.append_view_path File.join(File.dirname(__FILE__), '..', 'app', 'views')
    end
  end
end

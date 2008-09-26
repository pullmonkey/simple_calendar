class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table :simple_calendars do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :simple_calendars
  end
end

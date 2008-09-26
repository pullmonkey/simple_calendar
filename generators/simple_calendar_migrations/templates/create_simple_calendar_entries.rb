class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table :simple_calendar_entries do |t|
      t.references :simple_calendar
      t.string :name
      t.text :detail
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end

  def self.down
    drop_table :simple_calendar_entries
  end
end

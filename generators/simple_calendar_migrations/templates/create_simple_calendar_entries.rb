class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table :simple_calendar_entries do |t|
      t.column :simple_calendar_id, :integer, :limit => 11
      t.column :name,       :string
      t.column :detail,     :text
      t.column :start_time, :datetime
      t.column :end_time,   :datetime
      t.column :created_by, :string
      t.column :updated_by, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :simple_calendar_entries
  end
end

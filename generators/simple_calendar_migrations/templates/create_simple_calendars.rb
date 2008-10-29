class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table :simple_calendars do |t|
      t.column :name,       :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :simple_calendars
  end
end

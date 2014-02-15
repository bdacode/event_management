class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :google_calendars do |t|
      t.string :calendar_id
      t.string :summary
      t.string :kind
      t.string :location

      t.timestamps
    end
  end
end

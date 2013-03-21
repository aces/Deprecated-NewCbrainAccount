class AddDemandsTable < ActiveRecord::Migration
  def self.up
    create_table :demands do |t|

      t.string   "title"
      t.string   "first"
      t.string   "middle"
      t.string   "last"

      t.string   "institution"
      t.string   "department"
      t.string   "position"
      t.string   "email"

      t.string   "street1"
      t.string   "street2"
      t.string   "city"
      t.string   "province"
      t.string   "country"
      t.string   "postal_code"

      t.string   "time_zone"

      t.string   "service"
      t.string   "comment"

      t.string   "session_id"
      t.string   "confirm_token"
      t.boolean  "confirmed"

      t.string    "approved_by"
      t.datetime  "approved_at"

      t.timestamps
    end
  end

  def self.down
    drop_table :demands
  end
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130326174630) do

  create_table "demands", :force => true do |t|
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
    t.string   "approved_by"
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
  end

end

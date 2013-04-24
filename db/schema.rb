# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130418133834) do

  create_table "invoices", :force => true do |t|
    t.integer  "store_id"
    t.integer  "number"
    t.date     "issued"
    t.boolean  "paid"
    t.date     "paid_date"
    t.decimal  "total",      :precision => 8, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "invoices", ["issued"], :name => "index_invoices_on_issued"
  add_index "invoices", ["number"], :name => "index_invoices_on_number"
  add_index "invoices", ["store_id"], :name => "index_invoices_on_store_id"

  create_table "repairs", :force => true do |t|
    t.integer  "store_id"
    t.integer  "invoice_id"
    t.date     "received"
    t.date     "returned"
    t.string   "job"
    t.string   "name"
    t.text     "item"
    t.string   "serial"
    t.text     "service"
    t.decimal  "price",      :precision => 8, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "repairs", ["invoice_id"], :name => "index_repairs_on_invoice_id"
  add_index "repairs", ["received"], :name => "index_repairs_on_received"
  add_index "repairs", ["returned"], :name => "index_repairs_on_returned"
  add_index "repairs", ["serial"], :name => "index_repairs_on_serial"
  add_index "repairs", ["store_id"], :name => "index_repairs_on_store_id"

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "tel"
    t.string   "fax"
    t.string   "email"
    t.string   "contact"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

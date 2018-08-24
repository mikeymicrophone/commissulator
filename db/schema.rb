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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_08_24_191012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.index ["confirmation_token"], name: "index_agents_on_confirmation_token", unique: true
    t.index ["email"], name: "index_agents_on_email", unique: true
    t.index ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true
  end

  create_table "assistants", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate"
  end

  create_table "commissions", force: :cascade do |t|
    t.bigint "deal_id"
    t.bigint "agent_id"
    t.bigint "landlord_id"
    t.string "branch_name"
    t.string "tenant_name"
    t.string "tenant_email"
    t.string "tenant_phone_number"
    t.string "landlord_name"
    t.string "landlord_email"
    t.string "landlord_phone_number"
    t.string "agent_name"
    t.decimal "bedrooms"
    t.string "property_type"
    t.boolean "new_development"
    t.date "lease_start_date"
    t.string "lease_term"
    t.decimal "square_footage"
    t.decimal "listed_monthly_rent"
    t.string "landlord_source"
    t.string "tenant_source"
    t.integer "intranet_deal_number"
    t.boolean "copy_of_lease"
    t.string "property_address"
    t.string "apartment_number"
    t.string "zip_code"
    t.date "lease_sign_date"
    t.date "approval_date"
    t.decimal "leased_monthly_rent"
    t.decimal "commission_fee_percentage"
    t.decimal "agent_split_percentage"
    t.decimal "owner_pay_commission"
    t.decimal "listing_side_commission"
    t.decimal "tenant_side_commission"
    t.text "reason_for_fee_reduction"
    t.date "request_date"
    t.decimal "annualized_rent"
    t.decimal "total_commission"
    t.decimal "citi_commission"
    t.decimal "co_broke_commission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "referral_payment"
    t.boolean "co_exclusive_agency"
    t.string "co_exclusive_agency_name"
    t.boolean "exclusive_agency"
    t.string "exclusive_agency_name"
    t.boolean "exclusive_agent"
    t.string "exclusive_agent_name"
    t.string "exclusive_agent_office"
    t.boolean "open_listing"
    t.boolean "citi_habitats_agent"
    t.string "citi_habitats_agent_name"
    t.string "citi_habitats_agent_office"
    t.boolean "corcoran_agent"
    t.string "corcoran_agent_name"
    t.string "corcoran_agent_office"
    t.boolean "co_broke_company"
    t.string "co_broke_company_name"
    t.boolean "direct_deal"
    t.boolean "citi_habitats_referral_agent"
    t.string "citi_habitats_referral_agent_name"
    t.string "citi_habitats_referral_agent_office"
    t.decimal "citi_habitats_referral_agent_amount"
    t.boolean "corcoran_referral_agent"
    t.string "corcoran_referral_agent_name"
    t.string "corcoran_referral_agent_office"
    t.decimal "corcoran_referral_agent_amount"
    t.boolean "outside_agency"
    t.string "outside_agency_name"
    t.decimal "outside_agency_amount"
    t.boolean "relocation_referral"
    t.string "relocation_referral_name"
    t.decimal "relocation_referral_amount"
    t.boolean "listing_fee"
    t.string "listing_fee_name"
    t.string "listing_fee_office"
    t.decimal "listing_fee_percentage"
    t.datetime "deleted_at"
    t.integer "follow_up"
    t.index ["agent_id"], name: "index_commissions_on_agent_id"
    t.index ["deal_id"], name: "index_commissions_on_deal_id"
    t.index ["deleted_at"], name: "index_commissions_on_deleted_at"
    t.index ["landlord_id"], name: "index_commissions_on_landlord_id"
  end

  create_table "deals", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "unit_number"
    t.integer "status"
    t.bigint "agent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_deals_on_agent_id"
  end

  create_table "landlords", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "deal_id"
    t.bigint "assistant_id"
    t.integer "role"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate"
    t.decimal "adjustment"
    t.index ["assistant_id"], name: "index_participants_on_assistant_id"
    t.index ["deal_id"], name: "index_participants_on_deal_id"
  end

  add_foreign_key "participants", "assistants"
  add_foreign_key "participants", "deals"
end

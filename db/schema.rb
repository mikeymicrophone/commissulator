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

ActiveRecord::Schema.define(version: 2018_09_16_160532) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "agents", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate"
    t.string "payable_first_name"
    t.string "payable_last_name"
    t.integer "avatar_id"
  end

  create_table "apartments", force: :cascade do |t|
    t.string "unit_number"
    t.string "street_number"
    t.string "street_name"
    t.string "zip_code"
    t.string "size"
    t.decimal "rent"
    t.string "comment"
    t.bigint "registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_apartments_on_registration_id"
  end

  create_table "assists", force: :cascade do |t|
    t.bigint "deal_id"
    t.bigint "agent_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate"
    t.decimal "adjustment"
    t.decimal "expense"
    t.integer "role_id"
    t.index ["agent_id"], name: "index_assists_on_agent_id"
    t.index ["deal_id"], name: "index_assists_on_deal_id"
  end

  create_table "avatars", force: :cascade do |t|
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
    t.index ["confirmation_token"], name: "index_avatars_on_confirmation_token"
    t.index ["email"], name: "index_avatars_on_email"
    t.index ["reset_password_token"], name: "index_avatars_on_reset_password_token"
  end

  create_table "clients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "submitted_on"
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
    t.integer "package_id"
    t.index ["agent_id"], name: "index_deals_on_agent_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.bigint "deal_id"
    t.bigint "avatar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avatar_id"], name: "index_documents_on_avatar_id"
    t.index ["deal_id"], name: "index_documents_on_deal_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "variety"
    t.string "address"
    t.bigint "client_id"
    t.bigint "employer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_emails_on_client_id"
    t.index ["employer_id"], name: "index_emails_on_employer_id"
  end

  create_table "employers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employments", force: :cascade do |t|
    t.string "position"
    t.decimal "income"
    t.date "start_date"
    t.bigint "client_id"
    t.bigint "employer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_employments_on_client_id"
    t.index ["employer_id"], name: "index_employments_on_employer_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "involvements", force: :cascade do |t|
    t.bigint "package_id"
    t.bigint "role_id"
    t.decimal "rate"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_involvements_on_package_id"
    t.index ["role_id"], name: "index_involvements_on_role_id"
  end

  create_table "landlords", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leases", force: :cascade do |t|
    t.string "apartment_number"
    t.string "street_number"
    t.string "street_name"
    t.string "zip_code"
    t.bigint "landlord_id"
    t.bigint "client_id"
    t.bigint "registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_leases_on_client_id"
    t.index ["landlord_id"], name: "index_leases_on_landlord_id"
    t.index ["registration_id"], name: "index_leases_on_registration_id"
  end

  create_table "niches", force: :cascade do |t|
    t.bigint "employer_id"
    t.bigint "industry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employer_id"], name: "index_niches_on_employer_id"
    t.index ["industry_id"], name: "index_niches_on_industry_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.json "splits"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "phones", force: :cascade do |t|
    t.string "variety"
    t.string "number"
    t.bigint "client_id"
    t.bigint "employer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_phones_on_client_id"
    t.index ["employer_id"], name: "index_phones_on_employer_id"
  end

  create_table "referral_sources", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registrants", force: :cascade do |t|
    t.text "other_fund_sources"
    t.bigint "client_id"
    t.bigint "registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_registrants_on_client_id"
    t.index ["registration_id"], name: "index_registrants_on_registration_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.decimal "minimum_price"
    t.decimal "maximum_price"
    t.string "size"
    t.date "move_by"
    t.text "reason_for_moving"
    t.integer "occupants"
    t.string "pets"
    t.bigint "referral_source_id"
    t.bigint "agent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_registrations_on_agent_id"
    t.index ["referral_source_id"], name: "index_registrations_on_referral_source_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.decimal "rate"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "social_accounts", force: :cascade do |t|
    t.string "variety"
    t.string "url"
    t.string "moniker"
    t.bigint "client_id"
    t.bigint "employer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_social_accounts_on_client_id"
    t.index ["employer_id"], name: "index_social_accounts_on_employer_id"
  end

  add_foreign_key "apartments", "registrations"
  add_foreign_key "assists", "agents"
  add_foreign_key "assists", "deals"
  add_foreign_key "emails", "clients"
  add_foreign_key "emails", "employers"
  add_foreign_key "employments", "clients"
  add_foreign_key "employments", "employers"
  add_foreign_key "involvements", "packages"
  add_foreign_key "involvements", "roles"
  add_foreign_key "leases", "clients"
  add_foreign_key "leases", "landlords"
  add_foreign_key "leases", "registrations"
  add_foreign_key "niches", "employers"
  add_foreign_key "niches", "industries"
  add_foreign_key "phones", "clients"
  add_foreign_key "phones", "employers"
  add_foreign_key "registrants", "clients"
  add_foreign_key "registrants", "registrations"
  add_foreign_key "registrations", "referral_sources"
  add_foreign_key "social_accounts", "clients"
  add_foreign_key "social_accounts", "employers"
end

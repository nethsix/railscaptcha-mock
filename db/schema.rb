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

ActiveRecord::Schema.define(version: 20161027053224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_movs", force: :cascade do |t|
    t.integer  "user_id",                                          null: false
    t.integer  "payment_id"
    t.string   "description", limit: 100
    t.decimal  "amount",                  precision: 20, scale: 6
    t.string   "status",      limit: 10
    t.integer  "status_code", limit: 2
    t.string   "charge_type", limit: 2
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "blacklists", force: :cascade do |t|
    t.string   "cleaned_number",    limit: 15
    t.integer  "is_active",         limit: 2
    t.datetime "blacklisted_at"
    t.datetime "blacklisted_until"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "blacklist_reason",  limit: 50
    t.string   "comments",          limit: 250
    t.integer  "site_id"
  end

  create_table "carriers", force: :cascade do |t|
    t.string  "name",         limit: 250
    t.string  "brand_name",   limit: 250
    t.string  "company_name", limit: 250
    t.string  "logo_img",     limit: 100
    t.string  "country_iso",  limit: 2
    t.integer "main_mccmnc"
    t.string  "alt_mccmnc",   limit: 250
  end

  create_table "cities", force: :cascade do |t|
    t.string  "city_name",    limit: 100
    t.string  "area_code",    limit: 10
    t.integer "country_code"
    t.string  "country_iso",  limit: 2
  end

  create_table "countries", force: :cascade do |t|
    t.string  "name",                limit: 100
    t.boolean "service_available"
    t.string  "country_flag",        limit: 100
    t.boolean "autodetect"
    t.string  "country_code",        limit: 4
    t.string  "iso_code",            limit: 2
    t.string  "country_lang",        limit: 2
    t.string  "dialing_info",        limit: 250
    t.string  "process_chain",       limit: 250
    t.integer "valid_until"
    t.string  "dial_example",        limit: 20
    t.string  "child_country_codes"
    t.string  "default_locale",      limit: 5,   default: "en"
  end

  create_table "credits", force: :cascade do |t|
    t.integer  "user_id",                                                    null: false
    t.decimal  "amount",            precision: 20, scale: 6
    t.decimal  "amount_free",       precision: 20, scale: 6
    t.decimal  "emergency_balance", precision: 20, scale: 6, default: "0.0"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "enabled_countries", force: :cascade do |t|
    t.integer "app_id"
    t.string  "country_iso", limit: 2
  end

  create_table "features", force: :cascade do |t|
    t.string   "name",         limit: 50
    t.string   "description",  limit: 100
    t.string   "display_name", limit: 100
    t.string   "display_desc", limit: 250
    t.boolean  "is_active"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "metrics", force: :cascade do |t|
    t.string   "app",                          limit: 200, null: false
    t.string   "country",                      limit: 3,   null: false
    t.datetime "timestamp",                                null: false
    t.integer  "verified_numbers",                         null: false
    t.integer  "unique_numbers",                           null: false
    t.integer  "total_transactions",                       null: false
    t.float    "total_spend",                              null: false
    t.float    "latency"
    t.integer  "app_id",                                   null: false
    t.integer  "total_gateway_transactions",               null: false
    t.float    "total_gateway_spend",                      null: false
    t.integer  "success_gateway_transactions",             null: false
  end

  create_table "num_blocks", force: :cascade do |t|
    t.string   "country_iso",  limit: 2
    t.integer  "country_code", limit: 2
    t.string   "area_code",    limit: 2
    t.string   "city_name",    limit: 100
    t.string   "line_type",    limit: 50
    t.integer  "block_code"
    t.integer  "range_start",  limit: 2
    t.integer  "range_end",    limit: 2
    t.string   "carrier_name", limit: 255
    t.string   "company_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "status"
    t.decimal  "amount",                      precision: 20, scale: 6
    t.string   "trx_code",        limit: 20
    t.datetime "confirmed_at"
    t.datetime "expires_at"
    t.datetime "remind"
    t.boolean  "refunded"
    t.decimal  "amount_refunded",             precision: 20, scale: 6
    t.string   "attn_name",       limit: 100
    t.string   "company_name",    limit: 100
    t.string   "company_address", limit: 100
    t.integer  "invoice_number"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "provider_configs", force: :cascade do |t|
    t.integer  "provider_id"
    t.integer  "alt_provider"
    t.integer  "smart_provider"
    t.integer  "service_id"
    t.boolean  "is_default"
    t.decimal  "cost",                              precision: 20, scale: 6
    t.string   "fraction_mode"
    t.integer  "priority"
    t.string   "country_iso",           limit: 2
    t.string   "area_code",             limit: 5
    t.string   "phone_type",            limit: 30
    t.integer  "carrier_mnc"
    t.boolean  "smart_route_enabled"
    t.string   "company_name",          limit: 255
    t.integer  "user_id"
    t.integer  "outage_route"
    t.boolean  "is_outage_route"
    t.boolean  "has_unicode_support",                                        default: false, null: false
    t.boolean  "has_sender_id_support",                                      default: false, null: false
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
  end

  create_table "provider_costs", force: :cascade do |t|
    t.integer  "service_id"
    t.string   "country_iso", limit: 2
    t.string   "phone_type",  limit: 15
    t.integer  "mccmnc"
    t.integer  "provider_id"
    t.decimal  "cost",                   precision: 20, scale: 6, default: "0.0", null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  create_table "provider_phone_numbers", force: :cascade do |t|
    t.string   "name",               limit: 30
    t.string   "number",             limit: 15
    t.string   "formatted_number",   limit: 20
    t.string   "country_iso",        limit: 2
    t.boolean  "supports_int_calls",            default: true
    t.boolean  "is_active",                     default: true
    t.integer  "provider_id"
    t.integer  "service_id"
    t.datetime "locked_until"
  end

  create_table "ring_sessions", force: :cascade do |t|
    t.string   "site_key",                limit: 100,                                          null: false
    t.integer  "ph_id"
    t.integer  "site_id",                                                                      null: false
    t.string   "challenge_key",           limit: 100,                                          null: false
    t.integer  "status"
    t.string   "user_phone",              limit: 100
    t.integer  "attempt_counter",                                                              null: false
    t.integer  "method"
    t.integer  "current_service",                                              default: -1
    t.integer  "service_status",                                               default: -1
    t.string   "validation_code",         limit: 255
    t.integer  "loop_widget",             limit: 2,                            default: -1
    t.integer  "forced_sms",              limit: 2,                            default: -1
    t.datetime "identification_time"
    t.datetime "verification_time"
    t.datetime "expires_at"
    t.datetime "verification_expires_at"
    t.datetime "retry_at"
    t.boolean  "verified_waiting"
    t.boolean  "copied",                                                       default: false
    t.string   "server_phone"
    t.string   "user_country",            limit: 100
    t.string   "flag",                    limit: 10
    t.string   "tracking_id",             limit: 500
    t.string   "referer",                 limit: 255
    t.string   "user_agent",              limit: 255
    t.string   "ip_address",              limit: 100,                                          null: false
    t.string   "city_name",               limit: 100
    t.string   "internet_provider",       limit: 255
    t.integer  "user_device"
    t.float    "geo_lat"
    t.float    "geo_lng"
    t.integer  "geo_accuracy"
    t.float    "geo_alt"
    t.integer  "geo_alt_accuracy"
    t.boolean  "geolocation",                                                  default: false
    t.string   "culture",                 limit: 5
    t.integer  "validation_provider"
    t.string   "country_iso",             limit: 2
    t.string   "udid",                    limit: 50
    t.integer  "failure_counter"
    t.string   "threat_level",            limit: 20
    t.integer  "validation_counter",      limit: 2
    t.decimal  "amount_charged",                      precision: 20, scale: 6
    t.integer  "verified_with"
    t.string   "original_number",         limit: 20
    t.integer  "verification_id"
    t.string   "short_url_hash",          limit: 10
    t.string   "mob_ip",                  limit: 40
    t.string   "mob_id",                  limit: 40
    t.string   "dist_app_key",            limit: 100
    t.string   "custom_iosid",            limit: 20
    t.string   "custom_androidid",        limit: 100
    t.datetime "last_auto_retry_at"
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
  end

  create_table "route_changes", force: :cascade do |t|
    t.integer  "route_id"
    t.integer  "from_provider"
    t.integer  "to_provider"
    t.integer  "from_smart"
    t.integer  "to_smart"
    t.integer  "from_fallback"
    t.integer  "to_fallback"
    t.string   "explanation",   limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "service_plans", force: :cascade do |t|
    t.string  "name",                limit: 30
    t.string  "description",         limit: 250
    t.boolean "is_default"
    t.decimal "default_mobile",                  precision: 20, scale: 6, default: "0.0"
    t.decimal "default_landline",                precision: 20, scale: 6, default: "0.0"
    t.boolean "is_post_paid"
    t.decimal "monthly_fee",                     precision: 20, scale: 6, default: "0.0"
    t.boolean "charge_from_credits"
    t.decimal "amount_free",                     precision: 20, scale: 6, default: "0.0"
    t.decimal "min_amount",                      precision: 20, scale: 6, default: "0.0"
    t.integer "max_sms"
  end

  create_table "service_prices", force: :cascade do |t|
    t.integer "service_id",                                                          null: false
    t.string  "country_iso",     limit: 2
    t.decimal "price",                      precision: 20, scale: 6, default: "0.0"
    t.decimal "outage_price",               precision: 20, scale: 6, default: "0.0"
    t.string  "phone_type",      limit: 30
    t.integer "service_plan_id"
  end

  create_table "service_providers", force: :cascade do |t|
    t.string   "name"
    t.string   "provider_class_name"
    t.string   "user_account"
    t.string   "token_pass"
    t.string   "api_id"
    t.integer  "status"
    t.integer  "error_counter"
    t.string   "currency",            limit: 3
    t.boolean  "supports_unicode"
    t.boolean  "supports_sender_id",            default: false
    t.boolean  "is_active"
    t.string   "no_fallback_errors"
    t.integer  "user_id"
    t.integer  "timeout_ms",                    default: 0
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "services", force: :cascade do |t|
    t.string   "name",           limit: 45
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_code",                                       default: 0
    t.string   "service_class",  limit: 50
    t.string   "display_name",   limit: 25
    t.boolean  "is_active",                                          default: true
    t.decimal  "default_price",             precision: 20, scale: 6, default: "0.0"
    t.decimal  "default_mobile",            precision: 20, scale: 6, default: "0.0"
    t.boolean  "has_widget",                                         default: false
  end

  create_table "sessions", primary_key: "sess_id", force: :cascade do |t|
    t.string "sess_data", limit: 4000, null: false
    t.bigint "sess_time",              null: false
  end

  create_table "sites", force: :cascade do |t|
    t.string   "domain",                            limit: 2000
    t.string   "site_key",                          limit: 100,                      null: false
    t.string   "private_key",                       limit: 100,                      null: false
    t.string   "global_site",                       limit: 100,                      null: false
    t.string   "widget_type",                       limit: 50,                       null: false
    t.string   "app_type",                          limit: 50,   default: "WEBSITE", null: false
    t.integer  "user_id",                                                            null: false
    t.boolean  "duplicate_numbers"
    t.boolean  "user_geolocation",                               default: true
    t.boolean  "white_label",                                    default: false
    t.string   "custom_audio_dir",                  limit: 255
    t.string   "custom_audio_lang",                 limit: 255
    t.string   "custom_css_dir",                    limit: 255
    t.string   "custom_message"
    t.string   "custom_sender_id",                  limit: 50
    t.boolean  "inmediate_voice_fallback",                       default: false,     null: false
    t.boolean  "use_unicode_support",                            default: false,     null: false
    t.string   "ad_template",                       limit: 20
    t.string   "custom_support_email",              limit: 255
    t.integer  "custom_retry_timer"
    t.integer  "custom_session_timer"
    t.string   "store_ids"
    t.string   "app_name",                          limit: 100
    t.string   "app_schemes"
    t.string   "app_data"
    t.string   "unavailable_platform_fallback_url"
    t.boolean  "has_auto_retry",                                 default: false
    t.datetime "deleted_at"
    t.integer  "artist_id"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.index ["artist_id"], name: "index_sites_on_artist_id", using: :btree
  end

  create_table "stripe_charges", force: :cascade do |t|
    t.integer  "payment_id"
    t.string   "trx_id",           limit: 20
    t.decimal  "amount",                      precision: 20, scale: 6
    t.decimal  "amount_charged",              precision: 20, scale: 6
    t.decimal  "charge_fee",                  precision: 20, scale: 6
    t.string   "status",           limit: 10
    t.integer  "status_code"
    t.string   "card_type",        limit: 20
    t.string   "card_last4",       limit: 4
    t.string   "card_fingerprint", limit: 20
    t.string   "card_cvc_check",   limit: 10
    t.string   "card_country",     limit: 2
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "transaction_logs", force: :cascade do |t|
    t.integer  "service_id"
    t.string   "service_name",           limit: 100
    t.integer  "provider_id"
    t.string   "provider_name",          limit: 50
    t.integer  "site_id"
    t.integer  "user_id"
    t.string   "to_number",              limit: 20
    t.integer  "number_id"
    t.string   "country_code",           limit: 5
    t.string   "country_iso",            limit: 2
    t.string   "operator_name",          limit: 50
    t.decimal  "cost",                               precision: 20, scale: 6
    t.integer  "duration"
    t.string   "status",                 limit: 10
    t.string   "transaction_id",         limit: 100
    t.integer  "session_id"
    t.decimal  "amount_charged",                     precision: 20, scale: 6
    t.boolean  "refunded"
    t.decimal  "amount_refunded",                    precision: 20, scale: 6
    t.string   "sms_text",               limit: 250
    t.string   "sms_hash",               limit: 50
    t.string   "pin_code",               limit: 10
    t.integer  "carrier_mnc"
    t.string   "trx_id",                 limit: 50
    t.string   "status_message",         limit: 250
    t.integer  "route_id"
    t.boolean  "cost_checked"
    t.string   "referer",                limit: 255
    t.string   "udid",                   limit: 50
    t.string   "tracking_id",            limit: 500
    t.string   "ip_address",             limit: 100
    t.string   "session_token",          limit: 100
    t.string   "user_agent",             limit: 255
    t.integer  "message_length"
    t.integer  "message_count"
    t.integer  "is_unicode"
    t.decimal  "total_cost",                         precision: 20, scale: 6
    t.decimal  "phone_processing_cost",              precision: 20, scale: 6
    t.decimal  "phone_processing_price",             precision: 20, scale: 6
    t.integer  "provider_cost_id"
    t.string   "processors_list",        limit: 255
    t.boolean  "outage_route"
    t.string   "app_key",                limit: 100
    t.integer  "attempt"
    t.string   "city_name",              limit: 100
    t.float    "geo_lat"
    t.float    "geo_lng"
    t.integer  "geo_accuracy"
    t.float    "geo_alt"
    t.integer  "geo_alt_accuracy"
    t.boolean  "geolocation",                                                 default: false
    t.string   "sender_id",              limit: 20
    t.string   "culture",                limit: 20
    t.string   "delivery_mode",          limit: 15
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
  end

  create_table "user_alerts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "alert_type",    limit: 20
    t.string   "alert_trigger", limit: 30
    t.string   "recipient",     limit: 50
    t.string   "subject",       limit: 50
    t.string   "content"
    t.datetime "sent_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "user_features", force: :cascade do |t|
    t.integer  "feature_id"
    t.integer  "user_id"
    t.boolean  "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_phones", force: :cascade do |t|
    t.string   "original_number",     limit: 100,             null: false
    t.string   "cleaned_number",      limit: 100,             null: false
    t.string   "formatted_number",    limit: 20
    t.string   "country_iso",         limit: 2
    t.string   "country_code",        limit: 100
    t.string   "area_code",           limit: 5
    t.string   "block_number",        limit: 5
    t.string   "subscriber_number",   limit: 10
    t.string   "threat_level",        limit: 100
    t.string   "phid",                limit: 100
    t.integer  "city_id"
    t.string   "city_name",           limit: 100
    t.string   "neighborhood_name",   limit: 100
    t.float    "geo_lat"
    t.float    "geo_lng"
    t.integer  "geo_accuracy"
    t.float    "geo_alt"
    t.integer  "geo_alt_accuracy"
    t.string   "zip_code",            limit: 10
    t.integer  "q_verification"
    t.boolean  "is_reported"
    t.integer  "report_counter"
    t.integer  "type_of_line",        limit: 2
    t.string   "phone_type",          limit: 30
    t.string   "operator",            limit: 255
    t.integer  "carrier_id"
    t.integer  "carrier_mnc"
    t.string   "old_carrier",         limit: 100
    t.integer  "old_carrier_mnc"
    t.integer  "portability_counter",             default: 0
    t.string   "first_name",          limit: 100
    t.string   "last_name",           limit: 100
    t.string   "address",             limit: 255
    t.string   "facebook_id",         limit: 20
    t.string   "facebook_name",       limit: 100
    t.boolean  "white_pages_billed"
    t.datetime "white_page_query"
    t.datetime "last_updated_at"
    t.boolean  "is_valid"
    t.string   "udid",                limit: 50
    t.string   "carrier_name",        limit: 100
    t.integer  "carrier_code"
    t.string   "company_name",        limit: 255
    t.string   "status",              limit: 2
    t.string   "imsi_code",           limit: 20
    t.boolean  "is_ported"
    t.string   "cleansed_hash",       limit: 64
    t.string   "original_hash",       limit: 64
    t.string   "cleansed_salt",       limit: 24
    t.string   "original_salt",       limit: 24
    t.string   "cleansed_encrypted"
    t.string   "formatted_encrypted"
    t.integer  "idx_original"
    t.integer  "idx_cleansed"
    t.datetime "hlr_last_checked"
    t.string   "hlr_last_result",     limit: 500
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string   "address1",                     limit: 200
    t.string   "address2",                     limit: 200
    t.string   "phone",                        limit: 200
    t.string   "city",                         limit: 200
    t.string   "zip_code",                     limit: 200
    t.string   "country",                      limit: 200
    t.string   "company",                      limit: 200
    t.string   "role",                         limit: 200
    t.string   "area",                         limit: 200
    t.integer  "first_login"
    t.bigint   "verification_token"
    t.bigint   "verification_counter"
    t.bigint   "user_id"
    t.string   "change_email_temp",            limit: 510
    t.string   "verification_link_token",      limit: 80
    t.datetime "verification_link_expires_at"
    t.string   "registered_ip"
    t.string   "last_ip"
    t.string   "customer_stripe_id",           limit: 60
    t.string   "stripe_last4",                 limit: 4
    t.bigint   "stripe_exp_month"
    t.bigint   "stripe_exp_year"
    t.string   "stripe_card_fingerprint",      limit: 40
    t.string   "stripe_card_cvc_check",        limit: 20
    t.string   "stripe_card_type",             limit: 40
    t.string   "stripe_country",               limit: 4
    t.string   "customer_key"
    t.string   "customer_secret"
    t.bigint   "service_plan_id"
    t.datetime "last_low_credit_notified_at"
    t.datetime "last_monthly_charged_at"
    t.integer  "has_auto_reload"
    t.float    "auto_reload_amount"
    t.integer  "account_live_mode"
    t.string   "custom_notifications_emails",  limit: 510
    t.string   "login_type",                   limit: 510
    t.string   "github_access_token"
    t.bigint   "github_id"
    t.datetime "last_min_amount_charged_at"
    t.datetime "last_credit_reload_at"
    t.datetime "last_min_amount_expired_at"
    t.string   "github_username",              limit: 510
    t.string   "previous_service_plan",        limit: 40
    t.datetime "last_autoreload_attempt"
    t.float    "auto_reload_trigger_amount"
    t.datetime "first_transaction_at"
    t.bigint   "sms_count"
    t.string   "attn_name",                    limit: 510
    t.string   "company_name",                 limit: 510
    t.string   "company_address",              limit: 510
    t.datetime "next_counter_reset_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                                             default: "",    null: false
    t.string   "encrypted_password",                                                default: "",    null: false
    t.boolean  "is_active"
    t.boolean  "is_super_admin"
    t.integer  "profile_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",                                                   default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                                                        null: false
    t.datetime "updated_at",                                                                        null: false
    t.string   "name"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",                                                 default: 0
    t.string   "address1",                     limit: 100
    t.string   "address2",                     limit: 100
    t.string   "phone",                        limit: 100
    t.string   "city",                         limit: 100
    t.string   "zip_code",                     limit: 100
    t.string   "country",                      limit: 100
    t.string   "company",                      limit: 100
    t.string   "area",                         limit: 100
    t.boolean  "first_login",                                                       default: true
    t.integer  "verification_token"
    t.integer  "verification_counter"
    t.string   "change_email_temp",            limit: 255
    t.integer  "user_id"
    t.string   "verification_link_token",      limit: 40
    t.datetime "verification_link_expires_at"
    t.string   "registered_ip"
    t.string   "last_ip"
    t.string   "stripe_customer_id",           limit: 30
    t.string   "stripe_last4",                 limit: 4
    t.integer  "stripe_exp_month"
    t.integer  "stripe_exp_year"
    t.string   "stripe_card_fingerprint",      limit: 20
    t.string   "stripe_card_cvc_check",        limit: 20
    t.string   "stripe_card_type",             limit: 20
    t.string   "stripe_country",               limit: 2
    t.string   "customer_key"
    t.string   "customer_secret"
    t.integer  "service_plan_id"
    t.datetime "last_low_credit_notified_at"
    t.datetime "last_monthly_charged_at"
    t.boolean  "has_auto_reload"
    t.decimal  "auto_reload_amount",                       precision: 20, scale: 6
    t.boolean  "account_live_mode",                                                 default: false
    t.string   "custom_notifications_emails",  limit: 255
    t.datetime "last_min_amount_charged_at"
    t.datetime "last_credit_reload_at"
    t.datetime "last_min_amount_expired_at"
    t.integer  "github_id"
    t.string   "github_access_token"
    t.string   "github_username",              limit: 255
    t.datetime "last_autoreload_attempt"
    t.decimal  "auto_reload_trigger_amount",               precision: 20, scale: 6
    t.integer  "sms_count"
    t.datetime "first_transaction_at"
    t.string   "attn_name",                    limit: 100
    t.string   "company_name",                 limit: 100
    t.string   "company_address",              limit: 100
    t.datetime "next_counter_reset_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "verificateds", force: :cascade do |t|
    t.string   "site_key",            limit: 100,                 null: false
    t.integer  "ph_id"
    t.integer  "site_id",                                         null: false
    t.datetime "identification_time"
    t.datetime "verification_time"
    t.integer  "attempt_counter",                                 null: false
    t.integer  "method"
    t.string   "transaction_id",      limit: 100
    t.string   "tracking_id",         limit: 500
    t.string   "referer",             limit: 255
    t.string   "validation_code",     limit: 255
    t.string   "user_agent",          limit: 255
    t.string   "ip_address",          limit: 100,                 null: false
    t.string   "city_name",           limit: 100
    t.string   "internet_provider",   limit: 255
    t.integer  "user_device"
    t.float    "geo_lat"
    t.float    "geo_lng"
    t.integer  "geo_accuracy"
    t.float    "geo_alt"
    t.integer  "geo_alt_accuracy"
    t.boolean  "geolocation",                     default: false
    t.integer  "validation_provider"
    t.integer  "transaction_log"
    t.string   "country_iso",         limit: 2
    t.string   "udid",                limit: 50
    t.string   "threat_level",        limit: 20
    t.string   "status",              limit: 10
    t.string   "session_token",       limit: 100
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "whitelists", force: :cascade do |t|
    t.integer  "cleansed_number"
    t.integer  "verifications_allowed"
    t.string   "description",           limit: 250
    t.datetime "whitelisted_at"
    t.datetime "whitelisted_until"
    t.integer  "site_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

end

class CreateUserPhones < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :user_phone)
      rename_table :user_phone, :user_phones
      #add changes here
    else
      create_table :user_phones do |t|
        t.string   :original_number, null: false, limit: 100
        t.string   :cleaned_number, null: false, limit: 100, unique: true
        t.string   :formatted_number, null: true, limit: 20
        t.string   :country_iso, null: true, limit: 2
        t.string   :country_code, null: true, limit: 100
        t.string   :area_code, null: true, limit: 5
        t.string   :block_number, null: true, limit: 5
        t.string   :subscriber_number, null: true, limit: 10
        t.string   :threat_level, null: true, limit: 100
        t.string   :phid, null: true, limit: 100
        t.integer  :city_id, null: true
        t.string   :city_name, limit: 100
        t.string   :neighborhood_name, limit: 100
        t.float    :geo_lat, precision: 10, scale: 6, default: nil
        t.float    :geo_lng, precision: 10, scale: 6, default: nil
        t.integer  :geo_accuracy
        t.float    :geo_alt, precision: 10, scale: 6, default: nil
        t.integer  :geo_alt_accuracy
        t.string   :zip_code, null: true, limit: 10
        t.integer  :q_verification, null: true
        t.boolean  :is_reported
        t.integer  :report_counter
        t.integer  :type_of_line, limit: 1
        t.string   :phone_type, limit: 30
        t.string   :operator, limit: 255
        t.integer  :carrier_id
        t.integer  :carrier_mnc
        t.string   :old_carrier, limit: 100
        t.integer  :old_carrier_mnc
        t.integer  :portability_counter, default: 0
        t.string   :first_name, limit: 100
        t.string   :last_name, limit: 100
        t.string   :address, limit: 255
        t.string   :facebook_id, limit: 20
        t.string   :facebook_name, limit: 100
        t.boolean  :white_pages_billed
        t.datetime :white_page_query
        t.datetime :last_updated_at
        t.boolean  :is_valid
        t.string   :udid, limit: 50
        t.string   :carrier_name, limit: 100
        t.integer  :carrier_code
        t.string   :company_name, limit: 255
        t.string   :status, limit: 2
        t.string   :imsi_code, limit: 20
        t.boolean  :is_ported
        t.string   :cleansed_hash, limit: 64
        t.string   :original_hash, limit: 64
        t.string   :cleansed_salt, limit: 24
        t.string   :original_salt, limit: 24
        t.string   :cleansed_encrypted
        t.string   :formatted_encrypted
        t.integer  :idx_original, unsigned: true
        t.integer  :idx_cleansed, unsigned: true
        t.datetime :hlr_last_checked, default: nil
        t.string   :hlr_last_result, default: nil, limit: 500
        t.timestamps
      end
    end

  end
end

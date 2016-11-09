class CreateVerificateds < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :verificated)
      rename_table :verificated, :verificateds
      #add changes here
    else
      create_table :verificateds do |t|
        t.string   :site_key, null: false, limit: 100
        t.integer  :ph_id, null: true
        t.integer  :site_id, null: false
        t.datetime :identification_time
        t.datetime :verification_time
        t.integer  :attempt_counter, null: false
        t.integer  :method
        t.string   :transaction_id, limit: 100
        t.string   :tracking_id, limit: 500, default: nil
        t.string   :referer, limit: 255
        t.string   :validation_code, limit: 255
        t.string   :user_agent, limit: 255, null: true
        t.string   :ip_address, limit: 100, null: false
        t.string   :city_name, limit: 100
        t.string   :internet_provider, limit: 255
        t.integer  :user_device, default: nil
        t.float    :geo_lat, precision: 10, scale: 6, default: nil
        t.float    :geo_lng, precision: 10, scale: 6, default: nil
        t.integer  :geo_accuracy
        t.float    :geo_alt, precision: 10, scale: 6, default: nil
        t.integer  :geo_alt_accuracy
        t.boolean  :geolocation, default: false
        t.integer  :validation_provider
        t.integer  :transaction_log
        t.string   :country_iso, limit: 2
        t.string   :udid, limit: 50
        t.string   :threat_level, limit: 20
        t.string   :status, limit: 10
        t.string   :session_token, limit: 100
        t.timestamps
      end
    end
  end
end

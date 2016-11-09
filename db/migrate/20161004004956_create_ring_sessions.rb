class CreateRingSessions < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :ring_session)
      rename_table :ring_session, :ring_sessions
      #add changes here
    else

      create_table :ring_sessions do |t|
        t.string   :site_key, null: false, limit: 100
        t.integer  :ph_id, null: true
        t.integer  :site_id, null: false
        t.string   :challenge_key, null: false, limit: 100
        t.integer  :status
        t.string   :user_phone, null: true, limit: 100
        t.integer  :attempt_counter, null: false
        t.integer  :method
        t.integer  :current_service, default: -1
        t.integer  :service_status, default: -1
        t.string   :validation_code, limit: 255
        t.integer  :loop_widget, default: -1, limit: 2
        t.integer  :forced_sms, default: -1, limit: 2
        t.datetime :identification_time
        t.datetime :verification_time
        t.datetime :expires_at
        t.datetime :verification_expires_at
        t.datetime :retry_at
        t.boolean  :verified_waiting
        t.boolean  :copied, default: false
        t.string   :server_phone, null: true
        t.string   :user_country, limit: 100
        t.string   :flag, limit: 10
        t.string   :tracking_id, limit: 500, default: nil
        t.string   :referer, limit: 255
        t.string   :user_agent, limit: 255
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
        t.string   :culture, limit: 5
        t.integer  :validation_provider
        t.string   :country_iso, limit: 2
        t.string   :udid, limit: 50
        t.integer  :failure_counter
        t.string   :threat_level, limit: 20
        t.integer  :validation_counter, limit: 1
        t.decimal  :amount_charged, precision: 20, scale: 6
        t.integer  :verified_with, default: nil
        t.string   :original_number, limit: 20, default: nil
        t.integer  :verification_id
        t.string   :short_url_hash, limit: 10, default: nil
        t.string   :mob_ip, limit: 40
        t.string   :mob_id, limit: 40
        t.string   :dist_app_key, limit: 100
        t.string   :custom_iosid, limit: 20
        t.string   :custom_androidid, limit: 100
        t.datetime :last_auto_retry_at
        t.timestamps
      end
    end

  end
end

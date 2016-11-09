class CreateTransactionLogs < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :transaction_log)
      rename_table :transaction_log, :transaction_logs
      #add changes here
    else
      create_table :transaction_logs do |t|
        t.integer     :service_id
        t.string      :service_name, limit: 100
        t.integer     :provider_id
        t.string      :provider_name, limit: 50
        t.integer     :site_id
        t.integer     :user_id
        t.string      :to_number, limit: 20
        t.integer     :number_id
        t.string      :country_code, limit: 5
        t.string      :country_iso, limit: 2
        t.string      :operator_name, limit: 50
        t.decimal     :cost, precision: 20, scale: 6
        t.integer     :duration
        t.string      :status, limit: 10
        t.string      :transaction_id, limit: 100
        t.integer     :session_id
        t.decimal     :amount_charged, precision: 20, scale: 6
        t.boolean     :refunded
        t.decimal     :amount_refunded, precision: 20, scale: 6
        t.string      :sms_text, limit: 250
        t.string      :sms_hash, limit: 50
        t.string      :pin_code, limit: 10
        t.integer     :carrier_mnc
        t.string      :trx_id, limit: 50
        t.string      :status_message, limit: 250
        t.integer     :route_id
        t.boolean     :cost_checked
        t.string      :referer, limit: 255
        t.string      :udid, limit: 50
        t.string      :tracking_id, limit: 500
        t.string      :ip_address, limit: 100
        t.string      :session_token, limit: 100
        t.string      :user_agent, limit: 255
        t.integer     :message_length
        t.integer     :message_count
        t.integer     :is_unicode
        t.decimal     :total_cost, precision: 20, scale: 6
        t.decimal     :phone_processing_cost, precision: 20, scale: 6
        t.decimal     :phone_processing_price, precision: 20, scale: 6
        t.integer     :provider_cost_id
        t.string      :processors_list, limit: 255
        t.boolean     :outage_route
        t.string      :app_key, limit: 100
        t.integer     :attempt
        t.string      :city_name, limit: 100
        t.float       :geo_lat, precision: 10, scale: 6, default: nil
        t.float       :geo_lng, precision: 10, scale: 6, default: nil
        t.integer     :geo_accuracy
        t.float       :geo_alt, precision: 10, scale: 6, default: nil
        t.integer     :geo_alt_accuracy
        t.boolean     :geolocation, default: false
        t.string      :sender_id, limit: 20
        t.string      :culture, limit: 20
        t.string      :delivery_mode, limit: 15
        t.timestamps
      end
    end

  end
end

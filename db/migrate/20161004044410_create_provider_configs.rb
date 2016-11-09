class CreateProviderConfigs < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :provider_config)
      rename_table :provider_config, :provider_configs

      #no longer used.
      remove_column :provider_configs, :default_sender_id

    else
      create_table :provider_configs do |t|
        t.integer     :provider_id
        t.integer     :alt_provider
        t.integer     :smart_provider
        t.integer     :service_id
        t.boolean     :is_default
        t.decimal     :cost, precision: 20, scale: 6
        t.string      :fraction_mode
        t.integer     :priority
        t.string      :country_iso, limit: 2
        t.string      :area_code, limit: 5
        t.string      :phone_type, limit: 30
        t.integer     :carrier_mnc
        t.boolean     :smart_route_enabled
        t.string      :company_name, limit: 255
        t.integer     :user_id
        t.integer     :outage_route
        t.boolean     :is_outage_route
        t.boolean     :has_unicode_support, null: false, default: false
        t.boolean     :has_sender_id_support, null: false, default: false
        #t.string      :default_sender_id, limit: 20
        t.timestamps
      end
    end

  end
end

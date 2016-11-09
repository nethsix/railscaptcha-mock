class CreateServiceProviders < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :service_provider)
      rename_table :service_provider, :service_providers
      #add changes here
    else

      create_table :service_providers do |t|
        t.string      :name
        t.string      :provider_class_name
        t.string      :user_account
        t.string      :token_pass
        t.string      :api_id
        t.integer     :status
        t.integer     :error_counter
        t.string      :currency, limit: 3
        t.boolean     :supports_unicode
        t.boolean     :supports_sender_id, nil: false, default: false
        t.boolean     :is_active
        t.string      :no_fallback_errors
        t.integer     :user_id, default: nil
        t.integer     :timeout_ms, limit: 4, default: 0
        t.timestamps
      end
    end

  end
end

class CreateProviderPhoneNumbers < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :provider_phone_number)
      rename_table :provider_phone_number, :provider_phone_numbers
      #add changes here
    else
      create_table :provider_phone_numbers do |t|
        t.string      :name, limit: 30
        t.string      :number, limit: 15
        t.string      :formatted_number, limit: 20
        t.string      :country_iso, limit: 2
        t.boolean     :supports_int_calls, default: true
        t.boolean     :is_active, default: true
        t.integer     :provider_id
        t.integer     :service_id
        t.datetime    :locked_until
      end
    end

  end
end

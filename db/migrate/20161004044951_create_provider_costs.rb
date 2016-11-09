class CreateProviderCosts < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :provider_cost)
      rename_table :provider_cost, :provider_costs
      #add changes here
    else

      create_table :provider_costs do |t|
        t.integer     :service_id
        t.string      :country_iso, limit: 2
        t.string      :phone_type, limit: 15
        t.integer     :mccmnc
        t.integer     :provider_id
        t.decimal     :cost, precision: 20, scale: 6, null: false, default: 0
        t.timestamps
      end
    end

  end
end

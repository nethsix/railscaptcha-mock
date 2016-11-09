class CreateServicePrices < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :service_price)
      rename_table :service_price, :service_prices
      #add changes here
    else
      create_table :service_prices do |t|
        t.integer   :service_id, null: false
        t.string    :country_iso, limit: 2
        t.decimal   :price, precision: 20, scale: 6, default: 0
        t.decimal   :outage_price, precision: 20, scale: 6, default: 0
        t.string    :phone_type, limit: 30
        t.integer   :service_plan_id
      end
    end

  end
end

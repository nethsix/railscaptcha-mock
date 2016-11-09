class AddMetrics < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :metrics)

    else

      create_table :metrics do |t|
        t.string     :app, limit: 200, null: false
        t.string     :country, limit: 3, null: false
        t.timestamp  :timestamp, null: false
        t.integer :verified_numbers, null: false
        t.integer :unique_numbers, null: false
        t.integer :total_transactions, null: false
        t.float   :total_spend, precision: 20, scale: 6, null: false
        t.float   :latency, precision: 20, scale: 6
        t.integer :app_id, null: false
        t.integer :total_gateway_transactions, null: false
        t.float   :total_gateway_spend, precision: 20, scale: 6, null: false
        t.integer :success_gateway_transactions, null: false

      end
    end

  end
end

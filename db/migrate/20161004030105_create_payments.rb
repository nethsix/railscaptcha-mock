class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :payment)
      rename_table :payment, :payments
      #add changes here
    else

      create_table :payments do |t|
        t.integer  :status
        t.decimal  :amount, precision: 20, scale: 6
        t.string   :trx_code, limit: 20
        t.datetime :confirmed_at
        t.datetime :expires_at
        t.datetime :remind
        t.datetime :confirmed_at
        t.boolean  :refunded
        t.decimal  :amount_refunded, precision: 20, scale: 6
        t.string   :attn_name, limit: 100, default: nil
        t.string   :company_name, limit: 100, default: nil
        t.string   :company_address, limit: 100, default: nil
        t.integer  :invoice_number, defaul: nil, unique: true
        t.timestamps
      end
    end

  end
end

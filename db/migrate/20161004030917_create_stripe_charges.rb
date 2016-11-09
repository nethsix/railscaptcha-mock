class CreateStripeCharges < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :stripe_charge)
      rename_table :stripe_charge, :stripe_charges
      #add changes here
    else

      create_table :stripe_charges do |t|
        t.integer  :payment_id
        t.string   :trx_id, limit: 20
        t.decimal  :amount, precision: 20, scale: 6
        t.decimal  :amount_charged, precision: 20, scale: 6
        t.decimal  :charge_fee, precision: 20, scale: 6
        t.string   :status, limit: 10
        t.integer  :status_code
        t.string   :card_type, limit: 20
        t.string   :card_last4, limit: 4
        t.string   :card_fingerprint, limit: 20
        t.string   :card_cvc_check, limit: 10
        t.string   :card_country, limit: 2
        t.timestamps
      end
    end

  end
end

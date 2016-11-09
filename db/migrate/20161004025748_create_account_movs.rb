class CreateAccountMovs < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :account_mov)
      rename_table :account_mov, :account_movs

      #no longer used.
      remove_column :account_movs, :transaction_id
      remove_column :account_movs, :type
      remove_column :account_movs, :type_code

    else
      create_table :account_movs do |t|
        t.integer  :user_id, null: false
        t.integer  :payment_id
        #t.integer  :transaction_id
        #t.string   :type, limit: 6
        #t.integer  :type_code, limit: 1
        t.string   :description, limit: 100
        t.decimal  :amount, precision: 20, scale: 6
        t.string   :status, limit: 10
        t.integer  :status_code, limit: 1
        t.string   :charge_type, limit: 2, default: nil
        t.timestamps
      end
    end

  end
end

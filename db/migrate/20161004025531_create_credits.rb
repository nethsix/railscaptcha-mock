class CreateCredits < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :credits)
      #no longer used.
      remove_column :credits, :type_code
      remove_column :credits, :expires_at
      remove_column :credits, :remaining_credits

    else
      create_table :credits do |t|
        t.integer  :user_id, null: false
        t.decimal  :amount, precision: 20, scale: 6
        t.decimal  :amount_free, precision: 20, scale: 6
        #t.integer  :type_code, limit: 1
        #t.datetime :expires_at
        #t.decimal  :remaining_credits, precision: 20, scale: 6
        t.decimal  :emergency_balance, precision: 20, scale: 6, default: 0
        t.timestamps
      end
    end

  end
end

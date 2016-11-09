class CreateUserProfiles < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :user_profile)
      rename_table :user_profile, :user_profiles

      #redo primary keys
      #remove_column :user_profiles, :id
      #add_column :user_profiles, :id, :primary_key

    else

      create_table :user_profiles do |t|
        t.string  :address1, limit: 200
        t.string  :address2, limit: 200
        t.string  :phone, limit: 200
        t.string  :city, limit: 200
        t.string  :zip_code, limit: 200
        t.string  :country, limit: 200
        t.string  :company, limit: 200
        t.string  :role, limit: 200
        t.string  :area, limit: 200
        t.integer :first_login
        t.integer :verification_token, limit: 8
        t.integer :verification_counter, limit: 8
        t.integer :user_id, limit: 8
        t.string  :change_email_temp, limit: 510
        t.string  :verification_link_token, limit: 80
        t.datetime :verification_link_expires_at
        t.string  :registered_ip
        t.string  :last_ip
        t.string  :customer_stripe_id, limit: 60
        t.string  :stripe_last4, limit: 4
        t.integer :stripe_exp_month, limit: 8
        t.integer :stripe_exp_year, limit: 8
        t.string  :stripe_card_fingerprint, limit: 40
        t.string  :stripe_card_cvc_check, limit: 20
        t.string  :stripe_card_type, limit: 40
        t.string  :stripe_country, limit: 4
        t.string  :customer_key
        t.string  :customer_secret
        t.integer :service_plan_id, limit: 8
        t.datetime :last_low_credit_notified_at
        t.datetime :last_monthly_charged_at
        t.integer :has_auto_reload
        t.float   :auto_reload_amount, precision: 20, scale: 6, default: nil
        t.integer :account_live_mode
        t.string  :custom_notifications_emails, limit: 510
        t.string  :login_type, limit: 510
        t.string  :github_access_token
        t.integer :github_id, limit: 8
        t.datetime :last_min_amount_charged_at
        t.datetime :last_credit_reload_at
        t.datetime :last_min_amount_expired_at
        t.string  :github_username, limit: 510
        t.string  :previous_service_plan, limit: 40
        t.datetime :last_autoreload_attempt
        t.float   :auto_reload_trigger_amount, precision: 20, scale: 6, default: nil
        t.datetime :first_transaction_at
        t.integer :sms_count, limit: 8
        t.string  :attn_name, limit: 510
        t.string  :company_name, limit: 510
        t.string  :company_address, limit: 510
        t.datetime :next_counter_reset_at

        t.timestamps
      end
    end

  end
end

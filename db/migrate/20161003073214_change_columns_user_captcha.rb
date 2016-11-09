class ChangeColumnsUserCaptcha < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :address1, :string, limit: 100
    add_column :users, :address2, :string, limit: 100
    add_column :users, :phone, :string, limit: 100
    add_column :users, :city, :string, limit: 100
    add_column :users, :zip_code, :string, limit: 100
    add_column :users, :country, :string, limit: 100
    add_column :users, :company, :string, limit: 100
    add_column :users, :area, :string, limit: 100
    add_column :users, :first_login, :boolean, default: true
    add_column :users, :verification_token, :integer
    add_column :users, :verification_counter, :integer
    add_column :users, :change_email_temp, :string, limit: 255
    add_column :users, :user_id, :integer
    add_column :users, :verification_link_token, :string, limit: 40
    add_column :users, :verification_link_expires_at, :timestamp
    add_column :users, :registered_ip, :string
    add_column :users, :last_ip, :string
    add_column :users, :stripe_customer_id, :string, limit: 30
    add_column :users, :stripe_last4, :string, limit: 4
    add_column :users, :stripe_exp_month, :integer
    add_column :users, :stripe_exp_year, :integer
    add_column :users, :stripe_card_fingerprint, :string, limit: 20
    add_column :users, :stripe_card_cvc_check, :string, limit: 20
    add_column :users, :stripe_card_type, :string, limit: 20
    add_column :users, :stripe_country, :string, limit: 2
    add_column :users, :customer_key, :string
    add_column :users, :customer_secret, :string
    add_column :users, :service_plan_id, :integer
    add_column :users, :last_low_credit_notified_at, :timestamp
    add_column :users, :last_monthly_charged_at, :timestamp
    add_column :users, :has_auto_reload, :boolean
    add_column :users, :auto_reload_amount, :decimal, precision: 20, scale: 6
    add_column :users, :account_live_mode, :boolean, default: false
    add_column :users, :custom_notifications_emails, :string, limit: 255
    add_column :users, :last_min_amount_charged_at, :timestamp
    add_column :users, :last_credit_reload_at, :timestamp
    add_column :users, :last_min_amount_expired_at, :timestamp
    add_column :users, :github_id, :integer
    add_column :users, :github_access_token, :string
    add_column :users, :github_username, :string, limit: 255
    add_column :users, :last_autoreload_attempt, :timestamp
    add_column :users, :auto_reload_trigger_amount, :decimal, precision: 20, scale: 6
    add_column :users, :sms_count, :integer
    add_column :users, :first_transaction_at, :timestamp, default: nil
    add_column :users, :attn_name, :string, limit: 100, default: nil
    add_column :users, :company_name, :string, limit: 100, default: nil
    add_column :users, :company_address, :string, limit: 100, default: nil
    add_column :users, :next_counter_reset_at, :timestamp

  end
end

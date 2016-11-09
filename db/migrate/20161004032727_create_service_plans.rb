class CreateServicePlans < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :service_plan)
      rename_table :service_plan, :service_plans
      #add changes here
    else
      create_table :service_plans do |t|
        t.string    :name, limit: 30
        t.string    :description, limit: 250
        t.boolean   :is_default
        t.decimal   :default_mobile, precision: 20, scale: 6, default: 0
        t.decimal   :default_landline, precision: 20, scale: 6, default: 0
        t.boolean   :is_post_paid
        t.decimal   :monthly_fee, precision: 20, scale: 6, default: 0
        t.boolean   :charge_from_credits
        t.decimal   :amount_free, precision: 20, scale: 6, default: 0
        t.decimal   :min_amount, precision: 20, scale: 6, default: 0
        t.integer   :max_sms
      end
    end

  end
end

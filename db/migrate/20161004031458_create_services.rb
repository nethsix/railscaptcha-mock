class CreateServices < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :service)
      rename_table :service, :services

      #no longer used.
      remove_column :services, :unit

    else
      create_table :services do |t|
        t.string    :name, limit: 45
        #t.string    :unit, limit: 45
        t.datetime  :created_at
        t.datetime  :updated_at
        t.integer   :service_code, limit: 4, default: 0
        t.string    :service_class, limit: 50
        t.string    :display_name, limit: 25
        t.boolean   :is_active, default: true
        t.decimal   :default_price, precision: 20, scale: 6, default: 0
        t.decimal   :default_mobile, precision: 20, scale: 6, default: 0
        t.boolean   :has_widget, default: false
      end
    end

  end
end

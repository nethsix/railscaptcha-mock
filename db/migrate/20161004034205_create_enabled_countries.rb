class CreateEnabledCountries < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :enabled_country)
      rename_table :enabled_country, :enabled_countries
      #add changes here
    else
      create_table :enabled_countries do |t|
        t.integer  :app_id
        t.string   :country_iso, limit: 2
      end
    end

  end
end

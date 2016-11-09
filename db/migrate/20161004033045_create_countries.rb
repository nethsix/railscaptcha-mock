class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :country)
      rename_table :country, :countries
      #add changes here
    else
      create_table :countries do |t|
        t.string    :name, limit: 100
        t.boolean   :service_available
        t.string    :country_flag, limit: 100
        t.boolean   :autodetect
        t.string    :country_code, limit: 4
        t.string    :iso_code, limit: 2, unique: true
        t.string    :country_lang, limit: 2
        t.string    :dialing_info, limit: 250
        t.string    :process_chain, limit: 250
        t.integer   :valid_until
        t.string    :dial_example, limit: 20
        t.string    :child_country_codes
        t.string    :default_locale, limit: 5, default: 'en'
      end
    end

  end
end

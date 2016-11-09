class CreateCities < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :city)
      rename_table :city, :cities
      #add changes here
    else
      create_table :cities do |t|
        t.string    :city_name, limit: 100
        t.string    :area_code, limit: 10
        t.integer   :country_code
        t.string    :country_iso, limit: 2

      end
    end

  end
end

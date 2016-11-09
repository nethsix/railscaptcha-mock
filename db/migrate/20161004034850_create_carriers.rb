class CreateCarriers < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :carrier)
      rename_table :carrier, :carriers
      #add changes here
    else
      create_table :carriers do |t|
        t.string    :name, limit: 250
        t.string    :brand_name, limit: 250
        t.string    :company_name, limit: 250
        t.string    :logo_img, limit: 100
        t.string    :country_iso, limit: 2
        t.integer    :main_mccmnc
        t.string    :alt_mccmnc, limit: 250
      end
    end

  end
end

class CreateFeatures < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :feature)
      rename_table :feature, :features
      #add changes here
    else
      create_table :features do |t|
        t.string   :name, limit: 50
        t.string   :description, limit: 100
        t.string   :display_name, limit: 100
        t.string   :display_desc, limit: 250
        t.boolean  :is_active
        t.timestamps
      end
    end

  end
end

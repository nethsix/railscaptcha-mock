class ChangeConstraintLists < ActiveRecord::Migration[5.0]
  def change

###    execute('ALTER TABLE whitelists DROP CONSTRAINT whitelist_cleansed_number_site_id_key;')
###    execute('ALTER TABLE blacklists DROP CONSTRAINT blacklist_cleaned_number_site_id_key;')
    #remove_index :whitelists, name: :whitelist_cleansed_number_site_id_key
    #remove_index :blacklists, name: :blacklist_cleaned_number_site_id_key
  end
end

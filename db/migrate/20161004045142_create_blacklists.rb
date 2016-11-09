class CreateBlacklists < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :blacklist)
      rename_table :blacklist, :blacklists
      #add changes here
    else
      create_table :blacklists do |t|
        t.string      :cleaned_number, limit: 15
        t.integer     :is_active, limit: 1
        t.datetime    :blacklisted_at
        t.datetime    :blacklisted_until
        t.timestamps
        t.string      :blacklist_reason, limit: 50
        t.string      :comments, limit: 250
        t.integer     :site_id
      end
    end

  end
end

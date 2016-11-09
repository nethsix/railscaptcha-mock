class CreateWhitelists < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :whitelist)
      rename_table :whitelist, :whitelists
      #add changes here
    else

      create_table :whitelists do |t|
        t.integer     :cleansed_number
        t.integer     :verifications_allowed
        t.string      :description, limit: 250
        t.datetime    :whitelisted_at
        t.datetime    :whitelisted_until
        t.integer     :site_id
        t.timestamps
      end
    end

  end
end

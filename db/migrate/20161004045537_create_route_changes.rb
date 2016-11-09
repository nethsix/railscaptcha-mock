class CreateRouteChanges < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :route_change)
      rename_table :route_change, :route_changes
      #add changes here
    else
      create_table :route_changes do |t|
        t.integer     :route_id, default: nil
        t.integer     :from_provider, default: nil
        t.integer     :to_provider, default: nil
        t.integer     :from_smart, default: nil
        t.integer     :to_smart, default: nil
        t.integer     :from_fallback, default: nil
        t.integer     :to_fallback, default: nil
        t.string      :explanation, limit: 255
        t.timestamps
      end
    end

  end
end

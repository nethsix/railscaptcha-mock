class CreateNumBlocks < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :num_block)
      rename_table :num_block, :num_blocks
      #add changes here
    else

      create_table :num_blocks do |t|
        t.string    :country_iso, limit: 2
        t.integer   :country_code, limit: 2
        t.string    :area_code, limit: 2
        t.string    :city_name, limit: 100
        t.string    :line_type, limit: 50
        t.integer   :block_code, limit: 3
        t.integer   :range_start, limit: 2
        t.integer   :range_end, limit: 2
        t.string    :carrier_name, limit: 255
        t.string    :company_name, limit: 255
        t.timestamps
      end
    end

  end
end

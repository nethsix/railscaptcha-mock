#Session:
#  columns:
#    sess_id: { type: string(64), primary: true, notnull: true }
#    sess_data: { type: string(4000), notnull: true }
#    sess_time: { type: integer(4), notnull: true }

class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :sessions)
      #add changes here
    else
      create_table    :sessions, :id => false do |t|
        t.primary_key :sess_id, null: false, limit:  64
        t.string      :sess_data, null: false, limit: 4000
        t.integer     :sess_time, null: false, limit: 8
      end
    end

  end
end

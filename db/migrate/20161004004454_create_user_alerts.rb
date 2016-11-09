class CreateUserAlerts < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :user_alerts)
      #add changes here
    else

      create_table  :user_alerts do |t|
        t.integer   :user_id
        t.string    :alert_type, limit: 20
        t.string    :alert_trigger, limit: 30
        t.string    :recipient, limit: 50
        t.string    :subject, limit: 50
        t.string    :content
        t.datetime  :sent_at
        t.timestamps
      end
    end

  end
end

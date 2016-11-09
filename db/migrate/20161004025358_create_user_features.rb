class CreateUserFeatures < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :user_feature)
      rename_table :user_feature, :user_features
      #add changes here
    else

      create_table :user_features do |t|
        t.integer  :feature_id
        t.integer  :user_id
        t.boolean  :is_active
        t.timestamps
      end
    end

  end
end

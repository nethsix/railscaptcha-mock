class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :sf_guard_user)
      rename_table :sf_guard_user, :users

      #redo primary keys
      #remove_column :users, :id
      #add_column :users, :id, :primary_key

      rename_column :users, :email_address, :email
      remove_column :users, :username

      # After fixing the password, do this...
      remove_column :users, :algorithm # Always sha1
      rename_column :users, :salt, :legacy_password_salt
      rename_column :users, :password, :legacy_password

      #brough over in their current form.
      #rename_column :users,  :is_active
      #rename_column :users,  :is_super_admin
      #rename_column :users,  :profile_id

      add_column :users, :encrypted_password, :string

      ## Recoverable
      add_column :users, :reset_password_token, :string
      add_column :users, :reset_password_sent_at, :datetime

      ## Rememberable
      add_column :users, :remember_created_at, :datetime

      ## Trackable
      add_column :users, :sign_in_count, :integer, default: 0, null: false
      add_column :users, :current_sign_in_at, :datetime
      rename_column :users, :last_login, :last_sign_in_at
      add_column :users, :current_sign_in_ip, :inet
      add_column :users, :last_sign_in_ip, :inet

      ## Lockable
      add_column :users, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
      add_column :users, :unlock_token, :string # Only if unlock strategy is :email or :both
      add_column :users, :locked_at, :datetime

      User.update_all("encrypted_password=legacy_password")

      # This is needed otherwise MySQL barfs on index below (because DB arrives with 256 char field for email)
      # http://mechanics.flite.com/blog/2014/07/29/using-innodb-large-prefix-to-avoid-error-1071/
      #change_column :users, :email,                       :string,  limit: 255, null: false
    else
      create_table :users do |t|
        ## Database authenticatable
        t.string :email,              null: false, default: ""
        t.string :encrypted_password, null: false, default: ""

        #brought over in their current form.
        t.boolean  :is_active
        t.boolean  :is_super_admin
        t.integer  :profile_id

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        ## Trackable
        t.integer  :sign_in_count, default: 0, null: false
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.inet     :current_sign_in_ip
        t.inet     :last_sign_in_ip

        ## Lockable
        t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
        t.string   :unlock_token # Only if unlock strategy is :email or :both
        t.datetime :locked_at

        t.timestamps null: false
      end

      add_index :users, :email,                unique: true
      add_index :users, :reset_password_token, unique: true

      # add_index :users, :unlock_token,         unique: true
    end
  end
end
